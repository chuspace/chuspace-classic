# typed: true
# frozen_string_literal: true

class PostMarkdownService
  attr_reader :content, :markdown_doc, :title, :preview_image, :summary, :body_md, :body_html

  def initialize(content:)
    @title = nil
    @summary = nil
    @body_md = nil
    @preview_image = nil
    @body_html = nil

    @content = content
    @markdown_doc ||= CommonMarker.render_doc(content || '')
  end

  def self.call(content:)
    new(content: content).parse
  end

  def parse
    @markdown_doc.walk do |node|
      if node.type == :image
        @preview_image = url_or_mailto?(node.url) ? node.url : URI.join(ENV.fetch('CHUSPACE_URL'), node.url).to_s
        break
      end
    end

    @markdown_doc.each do |node|
      if title?(node) && @title.blank?
        @title = string_content_for(node).presence
        node.delete
        next
      end

      if summary?(node) && @summary.blank?
        @summary = string_content_for(node).presence
        node.delete
        next
      end

      @body_md = @markdown_doc
      @body_html = PostHtmlRenderer.new.render(@markdown_doc)

      break if @body_md.present?
    end

    self
  end

  private

  def title?(node)
    node.type == :header && node.header_level == 1
  end

  def summary?(node)
    node.type == :header && node.header_level == 2
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

  def url_or_mailto?(url_str)
    url = URI.parse(url_str)
    url.kind_of?(URI::HTTP) || url.kind_of?(URI::HTTPS) || url.kind_of?(URI::MailTo)
  end
end
