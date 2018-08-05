module FlexContainerHelper
  def flex_container(tag: :div, styles: [], &block)
    content = capture(&block)
    css_classes = classes.fetch_values(*styles).join(' ')
    content_tag(tag, content, class: "flex #{css_classes}")
  end

  private
    def classes
      {
        center: 'justify-center items-center',
        between: 'justify-between',
        around: 'justify-around',
        wrap: 'flex-wrap'
      }
    end
end
