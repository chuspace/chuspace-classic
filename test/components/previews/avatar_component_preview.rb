class AvatarComponentPreview < ViewComponent::Preview
  def with_avatar
    render(AvatarComponent.new(avatar_url: 'https:://github.com'))
  end
end
