module Avatarable
  AVATAR_VARIANTS = { sm: 32, md: 64, lg: 80, xl: 120, thumb: 150, profile: 250 }.freeze
  class AvatarVariantNotFound < StandardError; end

  extend ActiveSupport::Concern

  def avatar_url(variant: :sm)
    size = AVATAR_VARIANTS[variant] || fail(AvatarVariantNotFound, 'Avatar variant not found')
    avatar&.imgproxy_url(width: size * 2, height: size * 2, quality: 100, format: :png)
  end

  def gravatar_url(variant: :sm)
    size = AVATAR_VARIANTS[variant] || fail(AvatarVariantNotFound, 'Avatar variant not found')
    gravatar_id = Digest::MD5.hexdigest(email)
    "http://secure.gravatar.com/avatar/#{gravatar_id}?d=identicon&s=#{size}"
  end
end
