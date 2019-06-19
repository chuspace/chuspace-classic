#[macro_use]
extern crate rutie;
extern crate deunicode;
use rutie::{Module, Object, RString, VM};
use deunicode::deunicode_char;

module!(FastSlug);

methods!(
    FastSlug,
    _itself,

    fn pub_generate(text: RString) -> RString {
        let rust_string = text.
          map_err(|e| VM::raise_ex(e) ).
          unwrap()
          .to_string();

        let mut slug: Vec<u8> = Vec::with_capacity(rust_string.len());
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

            for character in rust_string.chars() {
                if character.is_ascii() {
                    (push_char)(character as u8);
                } else {
                    for &cx in deunicode_char(character).unwrap_or("-").as_bytes() {
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
        RString::new_utf8(&string)
    }
);

#[allow(non_snake_case)]
#[no_mangle]
pub extern "C" fn Init_fast_slug() {
   Module::from_existing("FastSlug").define(|itself| {
        itself.def_self("generate", pub_generate);
    });
}
