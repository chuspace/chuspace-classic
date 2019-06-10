#[macro_use]
extern crate rutie;
extern crate pulldown_cmark;
use rutie::{Module, Object, RString, VM};
use pulldown_cmark::{ Parser, Options, html, Event };

module!(FastMarkdown);

methods!(
    FastMarkdown,
    _itself,

    fn pub_to_html(markdown: RString) -> RString {
        let markdown_input = markdown.
          map_err(|e| VM::raise_ex(e) ).
          unwrap()
          .to_string();

        let mut options = Options::empty();
        options.insert(Options::ENABLE_STRIKETHROUGH);

        let events = Parser::new_ext(&markdown_input, options);
        let mut html_output = String::new();
        html::push_html(&mut html_output, events.into_iter());
        RString::new_utf8(&html_output)
    }

    fn pub_title(markdown: RString) -> RString {
        let markdown_input = markdown.
          map_err(|e| VM::raise_ex(e) ).
          unwrap().to_string();
        let mut title = String::with_capacity(100);
        let parser = Parser::new_ext(&markdown_input, Options::empty());

        for event in parser {
            if let Event::Text(text) = event {
                title = text.chars().take(100).collect();
                break;
            }
        }

        RString::new_utf8(&title)
    }
);

#[allow(non_snake_case)]
#[no_mangle]
pub extern "C" fn Init_fast_markdown() {
   Module::from_existing("FastMarkdown").define(|itself| {
        itself.def_self("to_html", pub_to_html);
        itself.def_self("title", pub_title);
    });
}
