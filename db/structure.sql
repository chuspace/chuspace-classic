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

SET default_tablespace = '';

-- Name: ar_internal_metadata; Type: TABLE

CREATE TABLE public.ar_internal_metadata (
    key character varying NOT NULL,
    value character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);

-- Name: collaborators; Type: TABLE

CREATE TABLE public.collaborators (
    id BIGSERIAL PRIMARY KEY,
    role integer,
    publication_id bigint NOT NULL,
    user_id bigint NOT NULL,
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

-- Name: events; Type: TABLE

CREATE TABLE public.events (
    id BIGSERIAL PRIMARY KEY,
    visit_id bigint,
    user_id bigint,
    name character varying,
    properties jsonb,
    "time" timestamp without time zone
);

-- Name: friendly_id_slugs; Type: TABLE

CREATE TABLE public.friendly_id_slugs (
    id BIGSERIAL PRIMARY KEY,
    slug character varying NOT NULL,
    sluggable_id integer NOT NULL,
    sluggable_type character varying(50),
    scope character varying,
    created_at timestamp without time zone
);

-- Name: invitations; Type: TABLE

CREATE TABLE public.invitations (
    id BIGSERIAL PRIMARY KEY,
    sender_id bigint NOT NULL,
    identifier character varying NOT NULL,
    role integer NOT NULL,
    publication_id bigint NOT NULL,
    code character varying NOT NULL,
    status integer DEFAULT 0 NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);

-- Name: keys; Type: TABLE

CREATE TABLE public.keys (
    id BIGSERIAL PRIMARY KEY,
    title character varying NOT NULL,
    key text NOT NULL,
    fingerprint character varying NOT NULL,
    user_id bigint NOT NULL,
    last_used timestamp without time zone,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);

-- Name: likes; Type: TABLE

CREATE TABLE public.likes (
    id BIGSERIAL PRIMARY KEY,
    post_id bigint NOT NULL,
    user_id bigint NOT NULL,
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
    likes_count integer DEFAULT 0 NOT NULL,
    ancestry character varying,
    topics character varying[] DEFAULT '{}'::character varying[],
    canonical_url character varying,
    published_at timestamp without time zone,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    unlisted boolean DEFAULT false,
    preview_image_data character varying,
    featured boolean,
    commit_sha text
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
    owner_id bigint NOT NULL,
    website character varying,
    twitter character varying,
    topics character varying[] DEFAULT '{}'::character varying[],
    posts_count integer DEFAULT 0 NOT NULL,
    collaborators_count integer DEFAULT 0 NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    unlisted boolean DEFAULT false
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
    first_name character varying NOT NULL,
    last_name character varying,
    email character varying NOT NULL,
    nickname character varying NOT NULL,
    avatar_data jsonb,
    auth_token character varying NOT NULL,
    auth_token_expires_at timestamp without time zone,
    bio text,
    company character varying,
    location character varying,
    url character varying,
    posts_count integer DEFAULT 0 NOT NULL,
    publications_count integer DEFAULT 0 NOT NULL,
    collaborations_count integer DEFAULT 0 NOT NULL,
    sign_in_count integer DEFAULT 0 NOT NULL,
    current_sign_in_at timestamp without time zone,
    last_sign_in_at timestamp without time zone,
    current_sign_in_ip inet,
    last_sign_in_ip inet,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);

-- Name: visits; Type: TABLE

CREATE TABLE public.visits (
    id BIGSERIAL PRIMARY KEY,
    visit_token character varying,
    visitor_token character varying,
    user_id bigint,
    ip character varying,
    user_agent text,
    referrer text,
    referring_domain character varying,
    landing_page text,
    browser character varying,
    os character varying,
    device_type character varying,
    country character varying,
    region character varying,
    city character varying,
    latitude double precision,
    longitude double precision,
    utm_source character varying,
    utm_medium character varying,
    utm_term character varying,
    utm_content character varying,
    utm_campaign character varying,
    app_version character varying,
    os_version character varying,
    platform character varying,
    started_at timestamp without time zone
);

ALTER TABLE ONLY public.ar_internal_metadata
    ADD CONSTRAINT ar_internal_metadata_pkey PRIMARY KEY (key);

ALTER TABLE ONLY public.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);

-- Name: delayed_jobs_priority; Type: INDEX

CREATE INDEX delayed_jobs_priority ON public.delayed_jobs USING btree (priority, run_at);

-- Name: index_collaborators_on_publication_id; Type: INDEX

CREATE INDEX index_collaborators_on_publication_id ON public.collaborators USING btree (publication_id);

-- Name: index_collaborators_on_publication_id_and_user_id; Type: INDEX

CREATE UNIQUE INDEX index_collaborators_on_publication_id_and_user_id ON public.collaborators USING btree (publication_id, user_id);

-- Name: index_collaborators_on_role; Type: INDEX

CREATE INDEX index_collaborators_on_role ON public.collaborators USING btree (role);

-- Name: index_collaborators_on_user_id; Type: INDEX

CREATE INDEX index_collaborators_on_user_id ON public.collaborators USING btree (user_id);

-- Name: index_events_on_name_and_time; Type: INDEX

CREATE INDEX index_events_on_name_and_time ON public.events USING btree (name, "time");

-- Name: index_events_on_properties; Type: INDEX

CREATE INDEX index_events_on_properties ON public.events USING gin (properties jsonb_path_ops);

-- Name: index_events_on_user_id; Type: INDEX

CREATE INDEX index_events_on_user_id ON public.events USING btree (user_id);

-- Name: index_events_on_visit_id; Type: INDEX

CREATE INDEX index_events_on_visit_id ON public.events USING btree (visit_id);

-- Name: index_friendly_id_slugs_on_slug_and_sluggable_type; Type: INDEX

CREATE INDEX index_friendly_id_slugs_on_slug_and_sluggable_type ON public.friendly_id_slugs USING btree (slug, sluggable_type);

-- Name: index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope; Type: INDEX

CREATE UNIQUE INDEX index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope ON public.friendly_id_slugs USING btree (slug, sluggable_type, scope);

-- Name: index_friendly_id_slugs_on_sluggable_type_and_sluggable_id; Type: INDEX

CREATE INDEX index_friendly_id_slugs_on_sluggable_type_and_sluggable_id ON public.friendly_id_slugs USING btree (sluggable_type, sluggable_id);

-- Name: index_invitations_on_code; Type: INDEX

CREATE UNIQUE INDEX index_invitations_on_code ON public.invitations USING btree (code);

-- Name: index_invitations_on_identifier; Type: INDEX

CREATE INDEX index_invitations_on_identifier ON public.invitations USING btree (identifier);

-- Name: index_invitations_on_identifier_and_publication_id; Type: INDEX

CREATE UNIQUE INDEX index_invitations_on_identifier_and_publication_id ON public.invitations USING btree (identifier, publication_id);

-- Name: index_invitations_on_publication_id; Type: INDEX

CREATE INDEX index_invitations_on_publication_id ON public.invitations USING btree (publication_id);

-- Name: index_invitations_on_sender_id; Type: INDEX

CREATE INDEX index_invitations_on_sender_id ON public.invitations USING btree (sender_id);

-- Name: index_keys_on_fingerprint; Type: INDEX

CREATE UNIQUE INDEX index_keys_on_fingerprint ON public.keys USING btree (fingerprint);

-- Name: index_keys_on_key; Type: INDEX

CREATE UNIQUE INDEX index_keys_on_key ON public.keys USING btree (key);

-- Name: index_keys_on_last_used; Type: INDEX

CREATE INDEX index_keys_on_last_used ON public.keys USING btree (last_used);

-- Name: index_keys_on_user_id; Type: INDEX

CREATE INDEX index_keys_on_user_id ON public.keys USING btree (user_id);

-- Name: index_likes_on_post_id; Type: INDEX

CREATE INDEX index_likes_on_post_id ON public.likes USING btree (post_id);

-- Name: index_likes_on_post_id_and_user_id; Type: INDEX

CREATE UNIQUE INDEX index_likes_on_post_id_and_user_id ON public.likes USING btree (post_id, user_id);

-- Name: index_likes_on_user_id; Type: INDEX

CREATE INDEX index_likes_on_user_id ON public.likes USING btree (user_id);

-- Name: index_posts_on_ancestry; Type: INDEX

CREATE INDEX index_posts_on_ancestry ON public.posts USING btree (ancestry);

-- Name: index_posts_on_author_id; Type: INDEX

CREATE INDEX index_posts_on_author_id ON public.posts USING btree (author_id);

-- Name: index_posts_on_blob_path_and_publication_id; Type: INDEX

CREATE UNIQUE INDEX index_posts_on_blob_path_and_publication_id ON public.posts USING btree (blob_path, publication_id);

-- Name: index_posts_on_commit_sha; Type: INDEX

CREATE INDEX index_posts_on_commit_sha ON public.posts USING btree (commit_sha);

-- Name: index_posts_on_featured; Type: INDEX

CREATE INDEX index_posts_on_featured ON public.posts USING btree (featured);

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

-- Name: index_posts_on_unlisted; Type: INDEX

CREATE INDEX index_posts_on_unlisted ON public.posts USING btree (unlisted);

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

-- Name: index_publications_on_unlisted; Type: INDEX

CREATE INDEX index_publications_on_unlisted ON public.publications USING btree (unlisted);

-- Name: index_topics_on_name; Type: INDEX

CREATE UNIQUE INDEX index_topics_on_name ON public.topics USING btree (name);

-- Name: index_users_on_auth_token; Type: INDEX

CREATE UNIQUE INDEX index_users_on_auth_token ON public.users USING btree (auth_token);

-- Name: index_users_on_email; Type: INDEX

CREATE UNIQUE INDEX index_users_on_email ON public.users USING btree (email);

-- Name: index_users_on_nickname; Type: INDEX

CREATE UNIQUE INDEX index_users_on_nickname ON public.users USING btree (nickname);

-- Name: index_visits_on_user_id; Type: INDEX

CREATE INDEX index_visits_on_user_id ON public.visits USING btree (user_id);

-- Name: index_visits_on_visit_token; Type: INDEX

CREATE UNIQUE INDEX index_visits_on_visit_token ON public.visits USING btree (visit_token);

-- Name: posts fk_rails_04d13ef8c7; Type: FK CONSTRAINT

ALTER TABLE ONLY public.posts
    ADD CONSTRAINT fk_rails_04d13ef8c7 FOREIGN KEY (author_id) REFERENCES public.users(id);

-- Name: invitations fk_rails_08fac6589b; Type: FK CONSTRAINT

ALTER TABLE ONLY public.invitations
    ADD CONSTRAINT fk_rails_08fac6589b FOREIGN KEY (publication_id) REFERENCES public.publications(id);

-- Name: visits fk_rails_09e5e7c20b; Type: FK CONSTRAINT

ALTER TABLE ONLY public.visits
    ADD CONSTRAINT fk_rails_09e5e7c20b FOREIGN KEY (user_id) REFERENCES public.users(id);

-- Name: events fk_rails_0cb5590091; Type: FK CONSTRAINT

ALTER TABLE ONLY public.events
    ADD CONSTRAINT fk_rails_0cb5590091 FOREIGN KEY (user_id) REFERENCES public.users(id);

-- Name: likes fk_rails_1e09b5dabf; Type: FK CONSTRAINT

ALTER TABLE ONLY public.likes
    ADD CONSTRAINT fk_rails_1e09b5dabf FOREIGN KEY (user_id) REFERENCES public.users(id);

-- Name: collaborators fk_rails_2d564e3065; Type: FK CONSTRAINT

ALTER TABLE ONLY public.collaborators
    ADD CONSTRAINT fk_rails_2d564e3065 FOREIGN KEY (publication_id) REFERENCES public.publications(id);

-- Name: keys fk_rails_3d10ea6ad7; Type: FK CONSTRAINT

ALTER TABLE ONLY public.keys
    ADD CONSTRAINT fk_rails_3d10ea6ad7 FOREIGN KEY (user_id) REFERENCES public.users(id);

-- Name: collaborators fk_rails_3d4aaacbb1; Type: FK CONSTRAINT

ALTER TABLE ONLY public.collaborators
    ADD CONSTRAINT fk_rails_3d4aaacbb1 FOREIGN KEY (user_id) REFERENCES public.users(id);

-- Name: likes fk_rails_87a8aac469; Type: FK CONSTRAINT

ALTER TABLE ONLY public.likes
    ADD CONSTRAINT fk_rails_87a8aac469 FOREIGN KEY (post_id) REFERENCES public.posts(id);

-- Name: invitations fk_rails_892c9262cb; Type: FK CONSTRAINT

ALTER TABLE ONLY public.invitations
    ADD CONSTRAINT fk_rails_892c9262cb FOREIGN KEY (sender_id) REFERENCES public.users(id);

-- Name: publications fk_rails_8f49e7c7de; Type: FK CONSTRAINT

ALTER TABLE ONLY public.publications
    ADD CONSTRAINT fk_rails_8f49e7c7de FOREIGN KEY (owner_id) REFERENCES public.users(id);

-- Name: posts fk_rails_d5126cca81; Type: FK CONSTRAINT

ALTER TABLE ONLY public.posts
    ADD CONSTRAINT fk_rails_d5126cca81 FOREIGN KEY (publication_id) REFERENCES public.publications(id);

-- Name: events fk_rails_ef9e5ff5fb; Type: FK CONSTRAINT

ALTER TABLE ONLY public.events
    ADD CONSTRAINT fk_rails_ef9e5ff5fb FOREIGN KEY (visit_id) REFERENCES public.visits(id);

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
('20190822161805'),
('20190831120520'),
('20190831121959'),
('20190901104948'),
('20190901104958'),
('20190922093833'),
('20190922093918'),
('20190924171556'),
('20190924171625'),
('20190925075537'),
('20190925075609'),
('20190925080931'),
('20191007202001');

