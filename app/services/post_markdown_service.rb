# typed: true
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
  def self.call(content: content)
    new(content: content)
  end

  sig { returns(T.nilable(String)) }
  def title
    title_node = markdown_doc.first

    if title_node.type == :header && title_node.header_level == 1
      title = ''
      title_node.each do |subnode|
        title += subnode.string_content
      end
    end

    title
  end

  sig { returns(T.nilable(String)) }
  def slug
    FastSlug.generate(title || content[0..100])
  end

  sig { returns(T.nilable(String)) }
  def blob_path
    dirname = FasterPath.dirname(Post::ROOT_PATH)
    blob_path = FasterPath.plus(dirname, "#{slug}.md")
  end

  sig { returns(T.nilable(String)) }
  def summary
    summary_node = markdown_doc.to_a.second

    if summary_node.type == :header && summary_node.header_level == 2
      summary = ''
      summary_node.each do |subnode|
        summary += subnode.string_content
      end
    end

    summary
  end

  sig { returns(T.nilable(String)) }
  def body_html
    PostHtmlRenderer.new.render(markdown_doc)
  end
end
