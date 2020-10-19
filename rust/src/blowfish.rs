use std::ffi::{CStr, CString};
use std::os::raw::c_char;
use std::ptr::null_mut;

use crypto::blowfish::Blowfish;
use rustc_serialize::hex::{FromHex, ToHex};

use crate::util::ProcessType;

const PADDING_BYTE: u8 = 0;

#[no_mangle]
pub extern fn blowfish_new(key_p: *const c_char) -> *mut Blowfish {
    if key_p.is_null() {
        return null_mut();
    }
    let key: &[u8] = unsafe { CStr::from_ptr(key_p) }.to_bytes();

    let obj = Blowfish::new(key);
    let box_obj = Box::new(obj);

    Box::into_raw(box_obj)
}

#[no_mangle]
pub extern fn blowfish_encrypt(
    ptr: *mut Blowfish,
    input_p: *const c_char,
) -> *mut c_char {
    cipher_process(ptr, input_p, ProcessType::Encrypt)
}

#[no_mangle]
pub extern fn blowfish_decrypt(
    ptr: *mut Blowfish,
    input_p: *const c_char,
) -> *mut c_char {
    cipher_process(ptr, input_p, ProcessType::Decrypt)
}

fn cipher_process(ptr: *mut Blowfish, input_p: *const c_char, process_type: ProcessType) -> *mut c_char {
    use crypto::symmetriccipher::BlockEncryptor;
    if ptr.is_null() || input_p.is_null() {
        return null_mut();
    }
    let blowfish = unsafe { &mut *ptr };
    let block_size = blowfish.block_size();

    let input_cstr = unsafe { CStr::from_ptr(input_p) };
    let mut input_vec: Vec<u8> = vec![];
    let input: &[u8] = match process_type {
        ProcessType::Encrypt => {
            input_vec.extend_from_slice(input_cstr.to_bytes());
            &input_vec
        }
        ProcessType::Decrypt => {
            let str = input_cstr.to_str().unwrap();
            let raw = str.from_hex().unwrap();
            input_vec.extend_from_slice(&raw);
            &input_vec
        }
    };
    let input_len = fixed_len(input.len(), block_size);
    let mut input: Vec<u8> = input.to_vec();
    input.resize(input_len, PADDING_BYTE);
    let mut output = vec![0u8; input_len];
    for (ichunk, mut ochunk) in input.chunks(block_size).zip(output.chunks_mut(block_size)) {
        match process_type {
            ProcessType::Encrypt => {
                blowfish.encrypt_block(&ichunk, &mut ochunk)
            }
            ProcessType::Decrypt => {
                use crypto::symmetriccipher::BlockDecryptor;
                blowfish.decrypt_block(&ichunk, &mut ochunk)
            }
        }
    }
    let result = match process_type {
        ProcessType::Encrypt => output.to_hex(),
        ProcessType::Decrypt => {
            if let Some(index) = output.iter().position(|&b| b == PADDING_BYTE) {
                output.truncate(index);
            }
            unsafe { String::from_utf8_unchecked(output) }
        }
    };
    CString::new(result).unwrap().into_raw()
}

fn fixed_len(len: usize, block_size: usize) -> usize {
    let reminder = len % block_size;
    if reminder == 0 {
        len
    } else {
        len - reminder + block_size
    }
}

#[no_mangle]
pub extern fn blowfish_destroy(ptr: *mut Blowfish) {
    if ptr.is_null() {
        return;
    }
    let blowfish = unsafe { Box::from_raw(ptr) };
    drop(blowfish);
}

#[cfg(test)]
mod test {
    use std::ffi::CStr;
    use std::os::raw::c_char;

    use crate::blowfish::{blowfish_decrypt, blowfish_destroy, blowfish_encrypt, blowfish_new};

    #[test]
    fn blow_fish_test() {
        let key = b"hello\0";
        let input = b"world\0";
        let ptr = blowfish_new(key.as_ptr() as *const c_char);
        let cipher = blowfish_encrypt(ptr, input.as_ptr() as *const c_char);
        let str = unsafe { CStr::from_ptr(cipher) }.to_str().unwrap();
        assert_eq!("f3751bdaa36c0c03", str);
        let str = blowfish_decrypt(ptr, str.as_bytes().as_ptr() as *const c_char);
        let str = unsafe { CStr::from_ptr(str) }.to_str().unwrap();
        assert_eq!("world", str);
        blowfish_destroy(ptr);
    }
}