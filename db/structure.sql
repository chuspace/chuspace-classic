SET statement_timeout = 0;
SET lock_timeout = 0;

SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
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

SET default_with_oids = false;

-- Name: ar_internal_metadata; Type: TABLE

CREATE TABLE public.ar_internal_metadata (
    key character varying NOT NULL,
    value character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);

-- Name: editions; Type: TABLE

CREATE TABLE public.editions (
    id BIGSERIAL PRIMARY KEY,
    editor_id bigint NOT NULL,
    post_id bigint NOT NULL,
    branch_name character varying NOT NULL,
    commit_sha character varying NOT NULL,
    status integer DEFAULT 0 NOT NULL,
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
    repository_id bigint NOT NULL,
    ancestry character varying,
    topics character varying[] DEFAULT '{}'::character varying[],
    published_at timestamp without time zone,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    log_data jsonb
);

-- Name: repositories; Type: TABLE

CREATE TABLE public.repositories (
    id BIGSERIAL PRIMARY KEY,
    name character varying DEFAULT 'blog'::character varying NOT NULL,
    full_name character varying NOT NULL,
    path character varying NOT NULL,
    author_id bigint NOT NULL,
    posts_count integer DEFAULT 0 NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);

-- Name: schema_migrations; Type: TABLE

CREATE TABLE public.schema_migrations (
    version character varying NOT NULL
);

-- Name: ssh_keys; Type: TABLE

CREATE TABLE public.ssh_keys (
    id BIGSERIAL PRIMARY KEY,
    title character varying,
    key text NOT NULL,
    fingerprint character varying NOT NULL,
    user_id bigint NOT NULL,
    last_used timestamp without time zone,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
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
    avatar character varying,
    auth_token character varying DEFAULT ''::character varying NOT NULL,
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

-- Name: index_editions_on_branch_name; Type: INDEX

CREATE UNIQUE INDEX index_editions_on_branch_name ON public.editions USING btree (branch_name);

-- Name: index_editions_on_commit_sha; Type: INDEX

CREATE INDEX index_editions_on_commit_sha ON public.editions USING btree (commit_sha);

-- Name: index_editions_on_editor_id; Type: INDEX

CREATE INDEX index_editions_on_editor_id ON public.editions USING btree (editor_id);

-- Name: index_editions_on_post_id; Type: INDEX

CREATE INDEX index_editions_on_post_id ON public.editions USING btree (post_id);

-- Name: index_editions_on_status; Type: INDEX

CREATE INDEX index_editions_on_status ON public.editions USING btree (status);

-- Name: index_posts_on_ancestry; Type: INDEX

CREATE INDEX index_posts_on_ancestry ON public.posts USING btree (ancestry);

-- Name: index_posts_on_author_id; Type: INDEX

CREATE INDEX index_posts_on_author_id ON public.posts USING btree (author_id);

-- Name: index_posts_on_blob_path_and_repository_id; Type: INDEX

CREATE UNIQUE INDEX index_posts_on_blob_path_and_repository_id ON public.posts USING btree (blob_path, repository_id);

-- Name: index_posts_on_published_at; Type: INDEX

CREATE INDEX index_posts_on_published_at ON public.posts USING btree (published_at);

-- Name: index_posts_on_repository_id; Type: INDEX

CREATE INDEX index_posts_on_repository_id ON public.posts USING btree (repository_id);

-- Name: index_posts_on_slug_and_repository_id; Type: INDEX

CREATE UNIQUE INDEX index_posts_on_slug_and_repository_id ON public.posts USING btree (slug, repository_id);

-- Name: index_posts_on_status; Type: INDEX

CREATE INDEX index_posts_on_status ON public.posts USING btree (status);

-- Name: index_posts_on_topics; Type: INDEX

CREATE INDEX index_posts_on_topics ON public.posts USING gin (topics);

-- Name: index_repositories_on_author_id; Type: INDEX

CREATE INDEX index_repositories_on_author_id ON public.repositories USING btree (author_id);

-- Name: index_repositories_on_full_name; Type: INDEX

CREATE UNIQUE INDEX index_repositories_on_full_name ON public.repositories USING btree (full_name);

-- Name: index_repositories_on_name_and_author_id; Type: INDEX

CREATE UNIQUE INDEX index_repositories_on_name_and_author_id ON public.repositories USING btree (name, author_id);

-- Name: index_repositories_on_path; Type: INDEX

CREATE UNIQUE INDEX index_repositories_on_path ON public.repositories USING btree (path);

-- Name: index_ssh_keys_on_fingerprint; Type: INDEX

CREATE UNIQUE INDEX index_ssh_keys_on_fingerprint ON public.ssh_keys USING btree (fingerprint);

-- Name: index_ssh_keys_on_key; Type: INDEX

CREATE UNIQUE INDEX index_ssh_keys_on_key ON public.ssh_keys USING btree (key);

-- Name: index_ssh_keys_on_last_used; Type: INDEX

CREATE INDEX index_ssh_keys_on_last_used ON public.ssh_keys USING btree (last_used);

-- Name: index_ssh_keys_on_user_id; Type: INDEX

CREATE INDEX index_ssh_keys_on_user_id ON public.ssh_keys USING btree (user_id);

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

-- Name: editions fk_rails_66ff8848eb; Type: FK CONSTRAINT

ALTER TABLE ONLY public.editions
    ADD CONSTRAINT fk_rails_66ff8848eb FOREIGN KEY (post_id) REFERENCES public.posts(id);

-- Name: repositories fk_rails_73e1e26d06; Type: FK CONSTRAINT

ALTER TABLE ONLY public.repositories
    ADD CONSTRAINT fk_rails_73e1e26d06 FOREIGN KEY (author_id) REFERENCES public.users(id);

-- Name: editions fk_rails_790d074ed3; Type: FK CONSTRAINT

ALTER TABLE ONLY public.editions
    ADD CONSTRAINT fk_rails_790d074ed3 FOREIGN KEY (editor_id) REFERENCES public.users(id);

-- Name: ssh_keys fk_rails_bacf7e1718; Type: FK CONSTRAINT

ALTER TABLE ONLY public.ssh_keys
    ADD CONSTRAINT fk_rails_bacf7e1718 FOREIGN KEY (user_id) REFERENCES public.users(id);

-- Name: posts fk_rails_d359178d0f; Type: FK CONSTRAINT

ALTER TABLE ONLY public.posts
    ADD CONSTRAINT fk_rails_d359178d0f FOREIGN KEY (repository_id) REFERENCES public.repositories(id);

-- PostgreSQL database dump complete

SET search_path TO "$user", public;

INSERT INTO "schema_migrations" (version) VALUES
('20180127181248'),
('20180127181249'),
('20190308201406'),
('20190416114847'),
('20190601073804'),
('20190706110353'),
('20190709114321'),
('20190709114322'),
('20190709114442'),
('20190716075119');

