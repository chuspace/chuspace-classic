# typed: false
# frozen_string_literal: true

class PostMarkdownService
  extend T::Sig
  attr_reader :content, :markdown_doc, :title, :summary, :body_md, :body_html

  sig { params(content: T.nilable(String)).returns(CommonMarker::Node) }
  def initialize(content:)
    @title = nil
    @summary = nil
    @body_md = nil
    @body_html = nil

    @content = content
    @markdown_doc ||= CommonMarker.render_doc(content || '')
  end

  sig { params(content: T.nilable(String)).returns(PostMarkdownService) }
  def self.call(content:)
    new(content: content).parse
  end

  sig { returns(T.nilable(PostMarkdownService)) }
  def parse
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

  sig { params(node: CommonMarker::Node).returns(T::Boolean) }
  def title?(node)
    node.type == :header && node.header_level == 1
  end

  sig { params(node: CommonMarker::Node).returns(T::Boolean) }
  def summary?(node)
    node.type == :header && node.header_level == 2
  end

  sig { params(node: CommonMarker::Node, content: String).returns(String) }
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
