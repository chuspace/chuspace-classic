module AvatarComponent
  property :href, required: true
  property :text, default: 'My button'

  def external_link?
    @href.starts_with? 'http'
  end
end
