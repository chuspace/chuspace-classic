#[macro_use]
extern crate helix;
#[macro_use]
extern crate lazy_static;
extern crate pulldown_cmark;
extern crate regex;

use pulldown_cmark::{ Parser, Options, html };
use regex::Regex;

lazy_static! {
  static ref PAGE_RE: Regex = Regex::new(r"^[[:space:]]*\-\-\-\r?\n((?s).*?(?-s))\-\-\-\r?\n?((?s).*(?-s))$").unwrap();
}

ruby! {
    class Euclid {
        def to_html(markdown: String) -> String {
            let markdown_input = &markdown.to_string();
            let mut options = Options::empty();
            options.insert(Options::ENABLE_STRIKETHROUGH);
            let parser = Parser::new_ext(markdown_input, options);

            let mut html_output = String::new();
            html::push_html(&mut html_output, parser);
            html_output
        }

        def split_content(content: String) -> String {
            let string = content.to_string();

            if !PAGE_RE.is_match(&string) {
               return "Couldn't find front matter in `{}`. Did you forget to add `---`?".to_string();
            }

            let caps = PAGE_RE.captures(&string).unwrap();
            caps[1].to_string()
        }
    }
}
