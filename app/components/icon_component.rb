class IconComponent < Components::Component
  DEFAULT_CSS_CLASS = 'icon'

  attribute :name
  attribute :css_class
  validates :name, presence: true

  def css_classes
    classes = [DEFAULT_CSS_CLASS]
    classes << css_class
    classes.join(' ')
  end

  def sprite_path
    @view.asset_pack_path('media/images/icons-sprite.svg')
  end

  def path
    sprite_path + '#' + name
  end
end
