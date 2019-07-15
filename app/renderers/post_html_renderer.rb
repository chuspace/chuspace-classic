# typed: true
# frozen_string_literal: true

class PostHtmlRenderer < CommonMarker::HtmlRenderer
  extend T::Sig

  def initialize
    super
    @headerid = 1
  end

  def header(node)
    block do
      out('<h', node.header_level, ' id="', @headerid, '">',
               :children, '</h', node.header_level, '>')
      @headerid += 1
    end
  end

  def link(node)
    if url_or_mailto?(node.url)
      out('<a href="', post_url.nil? ? '' : escape_href(post_url), '"')
      if node.title && !node.title.empty?
        out(' title="', escape_html(node.title), '"')
      end
      out(' target="', '_blank', '"')
      out(' rel="', 'noopener noreferrer', '"')
      out('>', :children, '</a>')
    else
      blob_path = node.url.start_with?('/') ? node.url[1..-1] : node.url
      blob_path_with_extension = FasterPath.extname(blob_path).blank? ? blob_path + '.md' : blob_path
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
      image_url = image ? image.image.imgproxy_url(width: 800, resizing_type: :fill) : node.url

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

  private

  def url_or_mailto?(url_str)
    url_str.kind_of?(URI::HTTP) || url_str.kind_of?(URI::HTTPS) || url_str.kind_of?(URI::MailTo)
  end
end
