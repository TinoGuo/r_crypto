use std::ffi::{CStr, CString};
use std::os::raw::c_char;
use std::ptr::null_mut;

use crypto::hmac::Hmac;
use crypto::mac::{Mac, MacResult};

#[no_mangle]
pub extern fn hmac(name: *const c_char, key: *const c_char, input: *const c_char) -> *mut c_char {
    let name_cstr = unsafe { CStr::from_ptr(name) }.to_str();
    let key_cstr = unsafe { CStr::from_ptr(key) }.to_str();
    let input_cstr = unsafe { CStr::from_ptr(input) }.to_str();
    if name_cstr.is_ok() && key_cstr.is_ok() && input_cstr.is_ok() {
        match hmac_internal(name_cstr.unwrap(),
                            key_cstr.unwrap().into(),
                            input_cstr.unwrap().into()) {
            Ok(str) => CString::new(str).unwrap().into_raw(),
            Err(_) => null_mut(),
        }
    } else {
        null_mut()
    }
}

fn hmac_internal(name: &str, key: String, input: String) -> Result<String, String> {
    use crypto::{md5::Md5, sha1::*, sha2::*, sha3::*, ripemd160::*, whirlpool::*};

    let key_vec = key.as_bytes();
    let input_vec = input.as_bytes();
    let action: fn(MacResult) -> Result<String, String> = |result: MacResult| {
        let vec = result.code();
        let result = vec.iter()
            .map(|b| format!("{:02x}", b))
            .collect();
        Ok(result)
    };

    match name {
        "md5" => {
            let mut sh = Hmac::new(Md5::new(), key_vec);
            sh.input(input_vec);
            action(sh.result())
        }
        "sha1" => {
            let mut sh = Hmac::new(Sha1::new(), key_vec);
            sh.input(input_vec);
            action(sh.result())
        }
        "sha224" => {
            let mut sh = Hmac::new(Sha224::new(), &key_vec);
            sh.input(&input_vec);
            action(sh.result())
        }
        "sha256" => {
            let mut sh = Hmac::new(Sha256::new(), &key_vec);
            sh.input(&input_vec);
            action(sh.result())
        }
        "sha384" => {
            let mut sh = Hmac::new(Sha384::new(), &key_vec);
            sh.input(&input_vec);
            action(sh.result())
        }
        "sha512" => {
            let mut sh = Hmac::new(Sha512::new(), &key_vec);
            sh.input(&input_vec);
            action(sh.result())
        }
        "sha512_trunc224" => {
            let mut sh = Hmac::new(Sha512Trunc224::new(), &key_vec);
            sh.input(&input_vec);
            action(sh.result())
        }
        "sha512_trunc256" => {
            let mut sh = Hmac::new(Sha512Trunc256::new(), &key_vec);
            sh.input(&input_vec);
            action(sh.result())
        }
        "sha3_224" => {
            let mut sh = Hmac::new(Sha3::sha3_224(), &key_vec);
            sh.input(&input_vec);
            action(sh.result())
        }
        "sha3_256" => {
            let mut sh = Hmac::new(Sha3::sha3_256(), &key_vec);
            sh.input(&input_vec);
            action(sh.result())
        }
        "sha3_384" => {
            let mut sh = Hmac::new(Sha3::sha3_384(), &key_vec);
            sh.input(&input_vec);
            action(sh.result())
        }
        "sha3_512" => {
            let mut sh = Hmac::new(Sha3::sha3_512(), &key_vec);
            sh.input(&input_vec);
            action(sh.result())
        }
        "shake_128" => {
            let mut sh = Hmac::new(Sha3::shake_128(), &key_vec);
            sh.input(&input_vec);
            action(sh.result())
        }
        "shake_256" => {
            let mut sh = Hmac::new(Sha3::shake_256(), &key_vec);
            sh.input(&input_vec);
            action(sh.result())
        }
        "keccak224" => {
            let mut sh = Hmac::new(Sha3::keccak224(), &key_vec);
            sh.input(&input_vec);
            action(sh.result())
        }
        "keccak256" => {
            let mut sh = Hmac::new(Sha3::keccak256(), &key_vec);
            sh.input(&input_vec);
            action(sh.result())
        }
        "keccak384" => {
            let mut sh = Hmac::new(Sha3::keccak384(), &key_vec);
            sh.input(&input_vec);
            action(sh.result())
        }
        "keccak512" => {
            let mut sh = Hmac::new(Sha3::keccak512(), &key_vec);
            sh.input(&input_vec);
            action(sh.result())
        }
        "ripemd160" => {
            let mut sh = Hmac::new(Ripemd160::new(), &key_vec);
            sh.input(&input_vec);
            action(sh.result())
        }
        "whirlpool" => {
            let mut sh = Hmac::new(Whirlpool::new(), &key_vec);
            sh.input(&input_vec);
            action(sh.result())
        }
        //TODO add more digest implementation
        _ => Err(String::from("unrecognized digest name"))
    }
}