# typed: true
# frozen_string_literal: true

class PostHtmlRenderer < CommonMarker::HtmlRenderer
  extend T::Sig

  def initialize
    super
    @count = 0
  end

  def header(node)
    header_class =
      if @count == 1 && node.header_level == 1
        'title'
      elsif @count == 2 && node.header_level == 2
        'summary'
      end

    slug = string_content_for(node).to_slug&.to_ascii&.normalize&.to_s

    block do
      out(
        '<h',
        node.header_level,
        ' id="',
        slug,
        '" class="',
        header_class,
        '">',
        :children,
        '</h',
        node.header_level,
        '>'
      )
    end
  end

  def link(node)
    if url_or_mailto?(node.url)
      out('<a href="', node.url.nil? ? '' : escape_href(node.url), '"')
      out(' title="', escape_html(node.title), '"') if node.title && !node.title.empty?
      out(' target="', '_blank', '"')
      out(' rel="', 'noopener noreferrer', '"')
      out('>', :children, '</a>')
    else
      blob_path = node.url.start_with?('/') ? node.url[1..-1] : node.url
      blob_path_with_extension = File.extname(blob_path).blank? ? blob_path + '.md' : blob_path
      post = Current.user.posts.find_by(blob_path: blob_path_with_extension)
      post_url = post ? Rails.application.routes.url_helpers.post_url(post) : node.url

      out('<a href="', post_url.nil? ? '' : escape_href(post_url), '"')
      out(' title="', escape_html(node.title), '"') if node.title && !node.title.empty?
      out('>', :children, '</a>')
    end
  end

  def image(node)
    if url_or_mailto?(node.url)
      super(node)
    else
      image_url = node.url
      blob_url = URI.join(ENV.fetch('CHUSPACE_URL'), image_url)
      image_url = Imgproxy.url_for(blob_url, width: 800, resizing_type: :fill)

      out('<lazy-image')
      out('src="', escape_href(image_url), '"')
      plain { out(' alt="', :children, '"') }
      out(' title="', escape_html(node.title), '"') if node.title && !node.title.empty?
      out(' >')
      out('</lazy-image>')
    end
  end

  def code_block(node)
    block do
      out("<code-editor#{sourcepos(node)}")

      out(' mode="', node.fence_info.split(/\s+/)[0], '"') if node.fence_info && !node.fence_info.empty?

      out(' content="', escape_html(node.string_content), '"')
      out(' readonly="nocursor"')
      out(' theme="light"')
      out('></code-editor>')
    end
  end

  def render(node)
    @count += 1 if node.type == :header
    super(node)
  end

  private

  def url_or_mailto?(url_str)
    url = URI.parse(url_str)
    T.unsafe(url.kind_of?(URI::HTTP)) || T.unsafe(url.kind_of?(URI::HTTPS)) || T.unsafe(url.kind_of?(URI::MailTo))
  end

  def string_content_for(node, content = '')
    node.each do |subnode|
      case subnode.type.to_sym
      when :text
        content += subnode.string_content
      else
        content += string_content_for(subnode)
      end
    end

    content
  end
end
