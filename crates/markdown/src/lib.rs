#[macro_use]
extern crate helix;
extern crate pulldown_cmark;
use pulldown_cmark::{ Parser, Options, html, Event, Tag };

ruby! {
    class Markdown {
        def to_html(markdown: String) -> String {
            let markdown_input = &markdown.to_string();
            let mut options = Options::empty();
            options.insert(Options::ENABLE_STRIKETHROUGH);
            let parser = Parser::new_ext(markdown_input, options);

            let mut html_output = String::new();
            html::push_html(&mut html_output, parser);
            html_output
        }

        def title(markdown: String) -> String {
            let markdown_input = &markdown.to_string();
            let mut title = String::with_capacity(100);
            let parser = Parser::new_ext(markdown_input, Options::empty());

            for event in parser {
                if let Event::Text(text) = event {
                    title = text.chars().take(100).collect();
                    break;
                }
            }

            title
        }

        def images(markdown: String) -> Vec<String> {
            let markdown_input = &markdown.to_string();
            let mut images = Vec::new();
            let parser = Parser::new_ext(markdown_input, Options::empty());

            for event in parser {
                if let Event::Start(Tag::Image(_, src, _)) = event {
                    images.push(src.to_string());
                }
            }

            images
        }
    }
}
