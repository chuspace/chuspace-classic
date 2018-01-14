# frozen_string_literal: true

Searchkick.client_options = {
  retry_on_failure: true,
  request_timeout: 5 * 60,
  randomize_hosts: true,
  reload_connections: true,
  reload_on_failure: true
}
