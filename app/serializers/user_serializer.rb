# frozen_string_literal: true

class UserSerializer
  include RouteHelpers
  include FastJsonapi::ObjectSerializer

  cache_options enabled: true, cache_length: 12.hours unless Rails.env.development?

  attributes :id, :name, :email, :nickname, :bio, :company, :github_nickname

  attribute :avatar_mini do |object|
    url_for(object.avatar.variant(resize_to_fit: [50, 50]))
  end

  attribute :avatar_thumbnail do |object|
    url_for(object.avatar.variant(resize_to_fit: [100, 100]))
  end

  attribute :avatar_large do |object|
    url_for(object.avatar.variant(resize_to_fit: [100, 100]))
  end
end
