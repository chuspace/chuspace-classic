# typed: true
class StatusBadgeComponent < Components::Component
  attribute :state, default: 'draft'
  attribute :css_class
  validates :state, presence: true, inclusion: { in: Edition.statuses.keys }

  def render
    @view.content_tag :div, state.titlecase, class: css_classes
  end

  private

  def css_classes
    classes = []
    classes << "badge badge--#{state}"
    classes << css_class if css_class
    classes.join(' ')
  end
end
