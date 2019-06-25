# frozen_string_literal: true

# typed: true
class MarkdownRenderer < Redcarpet::Render::HTML
  # Methods where the first argument is the text content

  %i[
    block_code
    block_quote
    block_html
    list
    list_item
    autolink
    codespan
    double_emphasis
    emphasis
    underline
    raw_html
    triple_emphasis
    strikethrough
    superscript
    highlight
    quote
    footnotes
    footnote_def
    footnote_ref
    entity
  ].each do |method|
    define_method method do |*args|
      super(*args)
    end
  end

  # Other methods where we don't return only a specific argument
  def link(link, title, content)
    super(link, title, content)
  end

  def image(link, title, content)
    content &&= content + ' '
    link = 'null'
    "#{content}![#{title}](#{link})"
  end

  def paragraph(text)
    text + "\n"
  end

  def header(text, header_level)
    '# ' * header_level + text + "\n"
  end

  def linebreak
    "\n"
  end
end
