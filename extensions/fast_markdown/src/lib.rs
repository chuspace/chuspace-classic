#[macro_use]
extern crate rutie;
extern crate pulldown_cmark;
extern crate pulldown_cmark_to_cmark;

use rutie::{Module, Object, RString, VM};
use pulldown_cmark::{ CowStr, Parser, Options, html, Event, Tag };
use pulldown_cmark_to_cmark::fmt::cmark;
use std::path::{ Path };


module!(FastMarkdown);

methods!(
    FastMarkdown,
    _itself,

    fn pub_parse(markdown: RString, asset_path: RString, post_path: RString) -> RString {
        let markdown_input = markdown.
          map_err(|e| VM::raise_ex(e) ).
          unwrap()
          .to_string();

        let asset_path_str = asset_path.
          map_err(|e| VM::raise_ex(e) ).
          unwrap()
          .to_string();

        let post_path_str = post_path.
          map_err(|e| VM::raise_ex(e) ).
          unwrap()
          .to_string();

        let events = Parser::new(&markdown_input).into_offset_iter().map(|(event, range)| {
            match event {
                Event::Start(Tag::Header(n)) => {
                    println!("this is range: {:#?}", range);
                    println!("this is range: {:#?}", n);

                    return Event::Start(Tag::Header(n));
                },
                Event::End(Tag::Image(link_type, src, title)) => {
                    println!("this is range: {:#?}", range);
                    if src.contains("//") {
                        return Event::End(Tag::Image(link_type, src, title));
                    };

                    if src.contains("mailto:") {
                        return Event::End(Tag::Image(link_type, src, title));
                    };

                    let mut src_path = Path::new("/").join(&asset_path_str).join(src.to_string());
                    let path: CowStr = src_path.to_string_lossy().to_string().into();

                    return Event::End(Tag::Image(link_type, path, title));
                },
                Event::End(Tag::Link(link_type, link, title)) => {
                    if link.contains("//") {
                        return Event::End(Tag::Link(link_type, link, title));
                    };

                    if link.contains("mailto:") {
                        return Event::End(Tag::Link(link_type, link, title));
                    };

                    let link_path = Path::new("/").join(&post_path_str).join(link.to_string());
                    let path: CowStr = link_path.to_string_lossy().to_string().into();

                    Event::End(Tag::Link(link_type, path, title))
                },
                _ => event
            }
        });

        let mut buf = String::with_capacity(markdown_input.len() + 128);
        cmark(events, &mut buf, None).unwrap();
        RString::new_utf8(&buf)
    }

    fn pub_to_html(markdown: RString) -> RString {
        let markdown_input = markdown.
          map_err(|e| VM::raise_ex(e) ).
          unwrap()
          .to_string();

        let parser = Parser::new_ext(&markdown_input, pulldown_cmark::Options::all());

        let mut html_output: String = String::with_capacity(markdown_input.len() * 3 / 2);
        html::push_html(&mut html_output, parser.into_iter());
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
        itself.def_self("parse", pub_parse);
        itself.def_self("to_html", pub_to_html);
        itself.def_self("title", pub_title);
    });
}
