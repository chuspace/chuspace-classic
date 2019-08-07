# typed: ignore
# frozen_string_literal: true

Rails.application.config.session_store :cookie_store, key: '_chuspace_session', domain: :all, tld_length: 2
