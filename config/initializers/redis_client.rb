# typed: true
# frozen_string_literal: true

class RedisClient
  attr_reader :config, :config_file_path, :instance

  class << self
    def config_path
      @config_path ||= Rails.root.join('config/redis.yml')
    end

    def config
      @config ||= YAML.load_file(config_path)[Rails.env].symbolize_keys
    end

    def instance
      @instance ||= Redis.new(url: config[:url])
    end
  end
end
