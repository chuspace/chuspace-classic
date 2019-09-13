module Avatarable
  AVATAR_VARIANTS = { sm: 32, md: 64, lg: 80, xl: 120, thumb: 150, profile: 250 }.freeze
  class AvatarVariantNotFound < StandardError; end

  extend ActiveSupport::Concern

  def avatar_url(variant: :sm)
    size = AVATAR_VARIANTS[variant] || fail(AvatarVariantNotFound, 'Avatar variant not found')
    avatar&.derivation_url(:thumbnail, size * 2, size * 2)
  end

  def gravatar_url(variant: :sm)
    size = AVATAR_VARIANTS[variant] || fail(AvatarVariantNotFound, 'Avatar variant not found')
    gravatar_id = Digest::MD5.hexdigest(email)
    "//secure.gravatar.com/avatar/#{gravatar_id}?d=identicon&s=#{size}"
  end
end
