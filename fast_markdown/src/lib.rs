#[macro_use]
extern crate rutie;
extern crate pulldown_cmark;
use rutie::{Module, Object, Class, RString, VM};
use pulldown_cmark::{ CowStr, Parser, Options, html, Event, Tag };

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

        let events = Parser::new_ext(&markdown_input, options).map(|event| {
            match event {
                Event::Start(Tag::Image(link_type, src, title)) => {
                    if src.contains("//") {
                        return Event::Start(Tag::Image(link_type, src, title));
                    };

                    if src.contains("mailto:") {
                        return Event::Start(Tag::Image(link_type, src, title));
                    };

                    let image_model_class = "Image".to_string();
                    let image_model_class_const = Class::from_existing(&image_model_class);

                    let args = RString::from(src.to_string()).into();
                    let url = image_model_class_const.send("url_for", Some(&[args]));

                    let url_string =  match url.try_convert_to::<RString>() {
                        Ok(string) => RString::new_utf8(&string.to_string()),
                        Err(_) => RString::new_utf8(&"Fail!".to_string()),
                    };

                    let mut cow_link: CowStr = url_string.to_string().into();
                    return Event::Start(Tag::Image(link_type, cow_link, title));
                },
                Event::Start(Tag::Link(link_type, link, title)) => {
                    if link.contains("//") {
                        return Event::Start(Tag::Link(link_type, link, title));
                    };

                    if link.contains("mailto:") {
                        return Event::Start(Tag::Link(link_type, link, title));
                    };

                    let post_model_class = "Post".to_string();
                    let post_model_class_const = Class::from_existing(&post_model_class);

                    let args = RString::from(link.to_string()).into();
                    let url = post_model_class_const.send("url_for", Some(&[args]));

                    let url_string =  match url.try_convert_to::<RString>() {
                        Ok(string) => RString::new_utf8(&string.to_string()),
                        Err(_) => RString::new_utf8(&"Fail!".to_string()),
                    };

                    let mut post_url: CowStr = url_string.to_string().into();
                    Event::Start(Tag::Link(link_type, post_url, title))
                },
                _ => event
            }
        });

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
