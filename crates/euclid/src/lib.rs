#[macro_use]
extern crate helix;
extern crate comrak;

use comrak::{ markdown_to_html, ComrakOptions };

ruby! {
    class Euclid {
        def to_html(markdown: String) -> String {
            let markdown_input = &markdown.to_string();
            let options = ComrakOptions {
                ext_strikethrough: true,
                github_pre_lang: true,
                ext_autolink: true,
                smart: true,
                ext_header_ids: Some("heading".to_string()),
                ..ComrakOptions::default()
            };

            markdown_to_html(markdown_input, &options).to_string()
        }
    }
}
