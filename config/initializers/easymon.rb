# typed: ignore
# frozen_string_literal: true

if Rails.env.production?
  Easymon::Repository.add('database', Easymon::ActiveRecordCheck.new(ActiveRecord::Base), :critical)
  Easymon::Repository.add('redis', Easymon::RedisCheck.new(RedisClient.config), :critical)
  Easymon::Repository.add('openssh', Easymon::SemaphoreCheck.new('openssh/sshd_config'), :critical)
end
