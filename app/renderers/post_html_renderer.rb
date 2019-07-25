# typed: true
# frozen_string_literal: true

class PostHtmlRenderer < CommonMarker::HtmlRenderer
  extend T::Sig

  def initialize
    super
    @headerid = 1
    @count = 0
  end

  def header(node)
    header_class = if @count == 1 && node.header_level == 1
      'title'
    elsif @count == 2 && node.header_level == 2
      'summary'
    end

    block do
      out('<h', node.header_level, ' id="', @headerid, '" class="', header_class, '">',
               :children, '</h', node.header_level, '>')
      @headerid += 1
    end
  end

  def link(node)
    if url_or_mailto?(node.url)
      out('<a href="', node.url.nil? ? '' : escape_href(node.url), '"')
      if node.title && !node.title.empty?
        out(' title="', escape_html(node.title), '"')
      end
      out(' target="', '_blank', '"')
      out(' rel="', 'noopener noreferrer', '"')
      out('>', :children, '</a>')

    else
      blob_path = node.url.start_with?('/') ? node.url[1..-1] : node.url
      blob_path_with_extension = File.extname(blob_path).blank? ? blob_path + '.md' : blob_path
      post = Current.user.posts.find_by(blob_path: blob_path_with_extension)
      post_url = post ? Rails.application.routes.url_helpers.post_url(post) : node.url

      out('<a href="', post_url.nil? ? '' : escape_href(post_url), '"')
      if node.title && !node.title.empty?
        out(' title="', escape_html(node.title), '"')
      end
      out('>', :children, '</a>')
    end
  end

  def image(node)
    if url_or_mailto?(node.url)
      super
    else
      blob_path = node.url.start_with?('/') ? node.url[1..-1] : node.url
      image = Current.user.images.find_by(blob_path: blob_path)
      image_url = image ? image.image_url(width: 800, resizing_type: :fill) : node.url

      out('<img src="', escape_href(image_url), '"')
      plain do
        out(' alt="', :children, '"')
      end
      if node.title && !node.title.empty?
        out(' title="', escape_html(node.title), '"')
      end
      out(' />')
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
end
