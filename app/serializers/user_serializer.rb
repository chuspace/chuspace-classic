# frozen_string_literal: true

class UserSerializer
  include RouteHelpers
  include FastJsonapi::ObjectSerializer

  cache_options enabled: true, cache_length: 12.hours
  attributes :id, :name, :email, :nickname, :bio, :website, :company,
             :location, :github_nickname

  attribute :avatar_mini do |object|
    url_for(object.avatar.variant(resize: '50x50'))
  end

  attribute :avatar_thumbnail do |object|
    url_for(object.avatar.variant(resize: '100x100'))
  end

  attribute :avatar_large do |object|
    url_for(object.avatar.variant(resize: '230x230'))
  end
end
