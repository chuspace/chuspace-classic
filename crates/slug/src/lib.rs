#[macro_use]
extern crate helix;
extern crate deunicode;

use deunicode::deunicode_char;

ruby! {
    class Slug {
       def generate(s: String) -> String {
            let mut slug: Vec<u8> = Vec::with_capacity(s.len());
            // Starts with true to avoid leading -
            let mut prev_is_dash = true;
            {
                let mut push_char = |x: u8| {
                    match x {
                        b'a'...b'z' | b'0'...b'9' => {
                            prev_is_dash = false;
                            slug.push(x);
                        }
                        b'A'...b'Z' => {
                            prev_is_dash = false;
                            // Manual lowercasing as Rust to_lowercase() is unicode
                            // aware and therefore much slower
                            slug.push(x - b'A' + b'a');
                        }
                        _ => {
                            if !prev_is_dash {
                                slug.push(b'-');
                                prev_is_dash = true;
                            }
                        }
                    }
                };

                 for c in s.chars() {
                    if c.is_ascii() {
                        (push_char)(c as u8);
                    } else {
                        for &cx in deunicode_char(c).unwrap_or("-").as_bytes() {
                            (push_char)(cx);
                        }
                    }
                }
            }

             // It's not really unsafe in practice, we know we have ASCII
            let mut string = unsafe { String::from_utf8_unchecked(slug) };
            if string.ends_with('-') {
                string.pop();
            }

             // We likely reserved more space than needed.
            string.shrink_to_fit();
            string
        }
    }
}
