SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET client_min_messages = warning;

-- Name: hstore; Type: EXTENSION

CREATE EXTENSION IF NOT EXISTS hstore WITH SCHEMA public;

-- Name: EXTENSION hstore; Type: COMMENT

-- Name: pg_trgm; Type: EXTENSION

CREATE EXTENSION IF NOT EXISTS pg_trgm WITH SCHEMA public;

-- Name: EXTENSION pg_trgm; Type: COMMENT

-- Name: unaccent; Type: EXTENSION

CREATE EXTENSION IF NOT EXISTS unaccent WITH SCHEMA public;

-- Name: EXTENSION unaccent; Type: COMMENT

-- Name: logidze_compact_history(jsonb); Type: FUNCTION

CREATE FUNCTION public.logidze_compact_history(log_data jsonb) RETURNS jsonb
    LANGUAGE plpgsql
    AS $$
          DECLARE
            merged jsonb;
          BEGIN
            merged := jsonb_build_object(
              'ts',
              log_data#>'{h,1,ts}',
              'v',
              log_data#>'{h,1,v}',
              'c',
              (log_data#>'{h,0,c}') || (log_data#>'{h,1,c}')
            );

            IF (log_data#>'{h,1}' ? 'm') THEN
              merged := jsonb_set(merged, ARRAY['m'], log_data#>'{h,1,m}');
            END IF;

            return jsonb_set(
              log_data,
              '{h}',
              jsonb_set(
                log_data->'h',
                '{1}',
                merged
              ) - 0
            );
          END;
        $$;

-- Name: logidze_exclude_keys(jsonb, text[]); Type: FUNCTION

CREATE FUNCTION public.logidze_exclude_keys(obj jsonb, VARIADIC keys text[]) RETURNS jsonb
    LANGUAGE plpgsql
    AS $$
          DECLARE
            res jsonb;
            key text;
          BEGIN
            res := obj;
            FOREACH key IN ARRAY keys
            LOOP
              res := res - key;
            END LOOP;
            RETURN res;
          END;
        $$;

-- Name: logidze_logger(); Type: FUNCTION

CREATE FUNCTION public.logidze_logger() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
          DECLARE
            changes jsonb;
            version jsonb;
            snapshot jsonb;
            new_v integer;
            size integer;
            history_limit integer;
            debounce_time integer;
            current_version integer;
            merged jsonb;
            iterator integer;
            item record;
            columns_blacklist text[];
            ts timestamp with time zone;
            ts_column text;
          BEGIN
            ts_column := NULLIF(TG_ARGV[1], 'null');
            columns_blacklist := COALESCE(NULLIF(TG_ARGV[2], 'null'), '{}');

            IF TG_OP = 'INSERT' THEN
              snapshot = logidze_snapshot(to_jsonb(NEW.*), ts_column, columns_blacklist);

              IF snapshot#>>'{h, -1, c}' != '{}' THEN
                NEW.log_data := snapshot;
              END IF;

            ELSIF TG_OP = 'UPDATE' THEN

              IF OLD.log_data is NULL OR OLD.log_data = '{}'::jsonb THEN
                snapshot = logidze_snapshot(to_jsonb(NEW.*), ts_column, columns_blacklist);
                IF snapshot#>>'{h, -1, c}' != '{}' THEN
                  NEW.log_data := snapshot;
                END IF;
                RETURN NEW;
              END IF;

              history_limit := NULLIF(TG_ARGV[0], 'null');
              debounce_time := NULLIF(TG_ARGV[3], 'null');

              current_version := (NEW.log_data->>'v')::int;

              IF ts_column IS NULL THEN
                ts := statement_timestamp();
              ELSE
                ts := (to_jsonb(NEW.*)->>ts_column)::timestamp with time zone;
                IF ts IS NULL OR ts = (to_jsonb(OLD.*)->>ts_column)::timestamp with time zone THEN
                  ts := statement_timestamp();
                END IF;
              END IF;

              IF NEW = OLD THEN
                RETURN NEW;
              END IF;

              IF current_version < (NEW.log_data#>>'{h,-1,v}')::int THEN
                iterator := 0;
                FOR item in SELECT * FROM jsonb_array_elements(NEW.log_data->'h')
                LOOP
                  IF (item.value->>'v')::int > current_version THEN
                    NEW.log_data := jsonb_set(
                      NEW.log_data,
                      '{h}',
                      (NEW.log_data->'h') - iterator
                    );
                  END IF;
                  iterator := iterator + 1;
                END LOOP;
              END IF;

              changes := hstore_to_jsonb_loose(
                hstore(NEW.*) - hstore(OLD.*)
              );

              new_v := (NEW.log_data#>>'{h,-1,v}')::int + 1;

              size := jsonb_array_length(NEW.log_data->'h');
              version := logidze_version(new_v, changes, ts, columns_blacklist);

              IF version->>'c' = '{}' THEN
                RETURN NEW;
              END IF;

              IF (
                debounce_time IS NOT NULL AND
                (version->>'ts')::bigint - (NEW.log_data#>'{h,-1,ts}')::text::bigint <= debounce_time
              ) THEN
                -- merge new version with the previous one
                new_v := (NEW.log_data#>>'{h,-1,v}')::int;
                version := logidze_version(new_v, (NEW.log_data#>'{h,-1,c}')::jsonb || changes, ts, columns_blacklist);
                -- remove the previous version from log
                NEW.log_data := jsonb_set(
                  NEW.log_data,
                  '{h}',
                  (NEW.log_data->'h') - (size - 1)
                );
              END IF;

              NEW.log_data := jsonb_set(
                NEW.log_data,
                ARRAY['h', size::text],
                version,
                true
              );

              NEW.log_data := jsonb_set(
                NEW.log_data,
                '{v}',
                to_jsonb(new_v)
              );

              IF history_limit IS NOT NULL AND history_limit = size THEN
                NEW.log_data := logidze_compact_history(NEW.log_data);
              END IF;
            END IF;

            return NEW;
          END;
          $$;

-- Name: logidze_snapshot(jsonb, text, text[]); Type: FUNCTION

CREATE FUNCTION public.logidze_snapshot(item jsonb, ts_column text, blacklist text[] DEFAULT '{}'::text[]) RETURNS jsonb
    LANGUAGE plpgsql
    AS $$
          DECLARE
            ts timestamp with time zone;
          BEGIN
            IF ts_column IS NULL THEN
              ts := statement_timestamp();
            ELSE
              ts := coalesce((item->>ts_column)::timestamp with time zone, statement_timestamp());
            END IF;
            return json_build_object(
              'v', 1,
              'h', jsonb_build_array(
                    logidze_version(1, item, ts, blacklist)
                  )
              );
          END;
        $$;

-- Name: logidze_version(bigint, jsonb, timestamp with time zone, text[]); Type: FUNCTION

CREATE FUNCTION public.logidze_version(v bigint, data jsonb, ts timestamp with time zone, blacklist text[] DEFAULT '{}'::text[]) RETURNS jsonb
    LANGUAGE plpgsql
    AS $$
          DECLARE
            buf jsonb;
          BEGIN
            buf := jsonb_build_object(
                    'ts',
                    (extract(epoch from ts) * 1000)::bigint,
                    'v',
                      v,
                      'c',
                      logidze_exclude_keys(data, VARIADIC array_append(blacklist, 'log_data'))
                    );
            IF coalesce(current_setting('logidze.meta', true), '') <> '' THEN
              buf := jsonb_set(buf, ARRAY['m'], current_setting('logidze.meta')::jsonb);
            END IF;
            RETURN buf;
          END;
        $$;

SET default_tablespace = '';

-- Name: ar_internal_metadata; Type: TABLE

CREATE TABLE public.ar_internal_metadata (
    key character varying NOT NULL,
    value character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);

-- Name: delayed_jobs; Type: TABLE

CREATE TABLE public.delayed_jobs (
    id BIGSERIAL PRIMARY KEY,
    priority integer DEFAULT 0 NOT NULL,
    attempts integer DEFAULT 0 NOT NULL,
    handler text NOT NULL,
    last_error text,
    run_at timestamp without time zone,
    locked_at timestamp without time zone,
    failed_at timestamp without time zone,
    locked_by character varying,
    queue character varying,
    created_at timestamp(6) without time zone,
    updated_at timestamp(6) without time zone
);

-- Name: keys; Type: TABLE

CREATE TABLE public.keys (
    id BIGSERIAL PRIMARY KEY,
    title character varying,
    key text NOT NULL,
    fingerprint character varying NOT NULL,
    user_id bigint NOT NULL,
    last_used timestamp without time zone,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);

-- Name: posts; Type: TABLE

CREATE TABLE public.posts (
    id BIGSERIAL PRIMARY KEY,
    title character varying,
    summary text,
    slug character varying NOT NULL,
    body_html text,
    blob_id character varying,
    blob_path character varying NOT NULL,
    status integer DEFAULT 0 NOT NULL,
    author_id bigint NOT NULL,
    publication_id bigint NOT NULL,
    ancestry character varying,
    topics character varying[] DEFAULT '{}'::character varying[],
    canonical_url character varying,
    published_at timestamp without time zone,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    log_data jsonb
);

-- Name: publications; Type: TABLE

CREATE TABLE public.publications (
    id BIGSERIAL PRIMARY KEY,
    name character varying NOT NULL,
    slug character varying NOT NULL,
    description text,
    avatar_data jsonb,
    repo_name character varying NOT NULL,
    repo_path character varying NOT NULL,
    personal boolean,
    internal boolean DEFAULT false NOT NULL,
    owner_id bigint NOT NULL,
    website character varying,
    twitter character varying,
    topics character varying[] DEFAULT '{}'::character varying[],
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);

-- Name: schema_migrations; Type: TABLE

CREATE TABLE public.schema_migrations (
    version character varying NOT NULL
);

-- Name: topics; Type: TABLE

CREATE TABLE public.topics (
    id BIGSERIAL PRIMARY KEY,
    name character varying NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);

-- Name: users; Type: TABLE

CREATE TABLE public.users (
    id BIGSERIAL PRIMARY KEY,
    name character varying DEFAULT ''::character varying NOT NULL,
    email character varying DEFAULT ''::character varying NOT NULL,
    nickname character varying DEFAULT ''::character varying NOT NULL,
    avatar_data jsonb,
    auth_token character varying DEFAULT ''::character varying NOT NULL,
    auth_token_expires_at timestamp without time zone,
    posts_count integer DEFAULT 0 NOT NULL,
    bio character varying,
    company character varying,
    location character varying,
    url character varying,
    sign_in_count integer DEFAULT 0 NOT NULL,
    current_sign_in_at timestamp without time zone,
    last_sign_in_at timestamp without time zone,
    current_sign_in_ip inet,
    last_sign_in_ip inet,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);

ALTER TABLE ONLY public.ar_internal_metadata
    ADD CONSTRAINT ar_internal_metadata_pkey PRIMARY KEY (key);

ALTER TABLE ONLY public.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);

-- Name: delayed_jobs_priority; Type: INDEX

CREATE INDEX delayed_jobs_priority ON public.delayed_jobs USING btree (priority, run_at);

-- Name: index_keys_on_fingerprint; Type: INDEX

CREATE UNIQUE INDEX index_keys_on_fingerprint ON public.keys USING btree (fingerprint);

-- Name: index_keys_on_key; Type: INDEX

CREATE UNIQUE INDEX index_keys_on_key ON public.keys USING btree (key);

-- Name: index_keys_on_last_used; Type: INDEX

CREATE INDEX index_keys_on_last_used ON public.keys USING btree (last_used);

-- Name: index_keys_on_user_id; Type: INDEX

CREATE INDEX index_keys_on_user_id ON public.keys USING btree (user_id);

-- Name: index_posts_on_ancestry; Type: INDEX

CREATE INDEX index_posts_on_ancestry ON public.posts USING btree (ancestry);

-- Name: index_posts_on_author_id; Type: INDEX

CREATE INDEX index_posts_on_author_id ON public.posts USING btree (author_id);

-- Name: index_posts_on_blob_path_and_publication_id; Type: INDEX

CREATE UNIQUE INDEX index_posts_on_blob_path_and_publication_id ON public.posts USING btree (blob_path, publication_id);

-- Name: index_posts_on_publication_id; Type: INDEX

CREATE INDEX index_posts_on_publication_id ON public.posts USING btree (publication_id);

-- Name: index_posts_on_published_at; Type: INDEX

CREATE INDEX index_posts_on_published_at ON public.posts USING btree (published_at);

-- Name: index_posts_on_slug_and_publication_id; Type: INDEX

CREATE UNIQUE INDEX index_posts_on_slug_and_publication_id ON public.posts USING btree (slug, publication_id);

-- Name: index_posts_on_status; Type: INDEX

CREATE INDEX index_posts_on_status ON public.posts USING btree (status);

-- Name: index_posts_on_topics; Type: INDEX

CREATE INDEX index_posts_on_topics ON public.posts USING gin (topics);

-- Name: index_publications_on_name; Type: INDEX

CREATE UNIQUE INDEX index_publications_on_name ON public.publications USING btree (name);

-- Name: index_publications_on_owner_id; Type: INDEX

CREATE INDEX index_publications_on_owner_id ON public.publications USING btree (owner_id);

-- Name: index_publications_on_owner_id_and_personal; Type: INDEX

CREATE UNIQUE INDEX index_publications_on_owner_id_and_personal ON public.publications USING btree (owner_id, personal);

-- Name: index_publications_on_repo_name; Type: INDEX

CREATE UNIQUE INDEX index_publications_on_repo_name ON public.publications USING btree (repo_name);

-- Name: index_publications_on_repo_path; Type: INDEX

CREATE UNIQUE INDEX index_publications_on_repo_path ON public.publications USING btree (repo_path);

-- Name: index_publications_on_slug; Type: INDEX

CREATE UNIQUE INDEX index_publications_on_slug ON public.publications USING btree (slug);

-- Name: index_publications_on_topics; Type: INDEX

CREATE INDEX index_publications_on_topics ON public.publications USING gin (topics);

-- Name: index_topics_on_name; Type: INDEX

CREATE UNIQUE INDEX index_topics_on_name ON public.topics USING btree (name);

-- Name: index_users_on_auth_token; Type: INDEX

CREATE UNIQUE INDEX index_users_on_auth_token ON public.users USING btree (auth_token);

-- Name: index_users_on_email; Type: INDEX

CREATE UNIQUE INDEX index_users_on_email ON public.users USING btree (email);

-- Name: index_users_on_nickname; Type: INDEX

CREATE UNIQUE INDEX index_users_on_nickname ON public.users USING btree (nickname);

-- Name: posts logidze_on_posts; Type: TRIGGER

CREATE TRIGGER logidze_on_posts BEFORE INSERT OR UPDATE ON public.posts FOR EACH ROW WHEN ((COALESCE(current_setting('logidze.disabled'::text, true), ''::text) <> 'on'::text)) EXECUTE PROCEDURE public.logidze_logger('5', 'updated_at', '{id, title, summary, body, author_id, blob_path, blob_id, repository_id, ancestry, status, topics, published_at, created_at, updated_at}');

-- Name: posts fk_rails_04d13ef8c7; Type: FK CONSTRAINT

ALTER TABLE ONLY public.posts
    ADD CONSTRAINT fk_rails_04d13ef8c7 FOREIGN KEY (author_id) REFERENCES public.users(id);

-- Name: keys fk_rails_3d10ea6ad7; Type: FK CONSTRAINT

ALTER TABLE ONLY public.keys
    ADD CONSTRAINT fk_rails_3d10ea6ad7 FOREIGN KEY (user_id) REFERENCES public.users(id);

-- Name: publications fk_rails_8f49e7c7de; Type: FK CONSTRAINT

ALTER TABLE ONLY public.publications
    ADD CONSTRAINT fk_rails_8f49e7c7de FOREIGN KEY (owner_id) REFERENCES public.users(id);

-- Name: posts fk_rails_d5126cca81; Type: FK CONSTRAINT

ALTER TABLE ONLY public.posts
    ADD CONSTRAINT fk_rails_d5126cca81 FOREIGN KEY (publication_id) REFERENCES public.publications(id);

-- PostgreSQL database dump complete

SET search_path TO "$user", public;

INSERT INTO "schema_migrations" (version) VALUES
('20180127181245'),
('20180127181248'),
('20190308201406'),
('20190416114847'),
('20190601073804'),
('20190706110353'),
('20190709114321'),
('20190709114322'),
('20190709114442'),
('20190822161805');

