# typed: false
# frozen_string_literal: true

class PostMarkdownService
  extend T::Sig

  attr_reader :content, :markdown_doc

  sig { params(content: T.nilable(String)).returns(CommonMarker::Node) }
  def initialize(content:)
    @content = content
    @markdown_doc ||= CommonMarker.render_doc(content || '')
  end

  sig { params(content: T.nilable(String)).returns(PostMarkdownService) }
  def self.call(content:)
    new(content: content)
  end

  sig { returns(T.nilable(String)) }
  def title
    title = nil

    markdown_doc.each do |node|
      title = string_content_for(node) if title?(node) || node.type == :header || node.type == :paragraph
      break if title.present?
    end

    title
  end

  sig { returns(T.nilable(String)) }
  def summary
    summary = nil

    markdown_doc.each do |node|
      next if title?(node) || string_content_for(node) == title

      summary = string_content_for(node) if summary?(node) || node.type == :header || node.type == :paragraph
      break if summary.present?
    end

    summary
  end

  sig { returns(T.nilable(String)) }
  def body_html
    PostHtmlRenderer.new.render(markdown_doc)
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
