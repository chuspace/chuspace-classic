# typed: false
# frozen_string_literal: true

if Rails.env.production?
  Easymon::Repository.add('database', Easymon::ActiveRecordCheck.new(ActiveRecord::Base), :critical)

  Easymon::Repository.add('redis', Easymon::RedisCheck.new(RedisClient.config), :critical)

  Easymon::Repository.add('memcached', Easymon::MemcachedCheck.new(Rails.cache))

  Easymon::Repository.add('elasticsearch', Easymon::HttpCheck.new(ElasticsearchClient.config), :critical)

  Easymon::Repository.add('ssh_keys', Easymon::SemaphoreCheck.new(Git.config.ssh_auth_file_path), :critical)

  Easymon::Repository.add('openssh', Easymon::SemaphoreCheck.new('openssh/sshd_config'), :critical)
end
