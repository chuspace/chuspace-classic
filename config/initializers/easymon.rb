# typed: ignore
# frozen_string_literal: true

if Rails.env.production?
  Easymon::Repository.add('Postgres', Easymon::ActiveRecordCheck.new(ActiveRecord::Base), :critical)
  Easymon::Repository.add('Rails cache', Easymon::MemcachedCheck.new(Rails.cache), :critical)
  Easymon::Repository.add('Anycable redis', Easymon::RedisCheck.new(url: ENV.fetch('ANYCABLE_REDIS_URL')), :critical)
  Easymon::Repository.add('Openssh', Easymon::SemaphoreCheck.new('openssh/sshd_config'), :critical)
  Easymon::Repository.add('Anycable', Easymon::HttpCheck.new('http://localhost:8081/alive'), :critical)
end
