use std::ptr::null;
use std::slice;

use blake2::{VarBlake2b, VarBlake2s};
use blake2::digest::Update;
use blake2::digest::VariableOutput;

macro_rules! common_process {
    ($blake: ident,
    $persona: expr,
    $persona_len: expr,
    $salt: expr,
    $salt_len: expr,
    $key: expr,
    $key_len: expr,
    $input: expr,
    $input_len: expr,
    $output: expr,
    $output_len: expr) => {
    let persona = if $persona != null() && $persona_len > 0 {
        unsafe { slice::from_raw_parts($persona, $persona_len as usize) }
    } else {
        empty_u8()
    };
    let salt = if $salt != null() && $salt_len > 0 {
        unsafe { slice::from_raw_parts($salt, $salt_len as usize) }
    } else {
        let tmp: &[u8] = &[];
        tmp
    };
    let key = if $key != null() && $key_len > 0 {
        unsafe { slice::from_raw_parts($key, $key_len as usize) }
    }  else {
        empty_u8()
    };
    let input = unsafe { slice::from_raw_parts($input, $input_len as usize) };
    let result = unsafe { slice::from_raw_parts_mut($output, $output_len as usize) };
    let mut blake2 = $blake::with_params(key, salt, persona, $output_len as usize);
    blake2.update(input);
    blake2.finalize_variable(|res| {
        result.copy_from_slice(res);
    });
    };
}

#[no_mangle]
pub extern fn blake2b(persona: *const u8,
                      persona_len: u32,
                      salt: *const u8,
                      salt_len: u32,
                      key: *const u8,
                      key_len: u32,
                      input: *const u8,
                      input_len: u32,
                      output: *mut u8,
                      output_len: u32) {
    common_process!(VarBlake2b, persona, persona_len, salt, salt_len, key, key_len, input, input_len, output, output_len);
}

#[no_mangle]
pub extern fn blake2s(persona: *const u8,
                      persona_len: u32,
                      salt: *const u8,
                      salt_len: u32,
                      key: *const u8,
                      key_len: u32,
                      input: *const u8,
                      input_len: u32,
                      output: *mut u8,
                      output_len: u32) {
    common_process!(VarBlake2s, persona, persona_len, salt, salt_len, key, key_len, input, input_len, output, output_len);
}

fn empty_u8() -> &'static [u8] {
    let tmp: &[u8] = &[];
    tmp
}

#[cfg(test)]
mod test {
    use std::ptr::null;

    use rustc_serialize::hex::ToHex;

    use crate::blake2::{blake2b, blake2s};

    #[test]
    fn blake2b_512_test() {
        let input = "hello".as_bytes();
        let mut output = [0u8; 64];
        blake2b(null(), 0, null(), 0, null(), 0, input.as_ptr(), input.len() as u32, output.as_mut_ptr(), output.len() as u32);
        assert_eq!("e4cfa39a3d37be31c59609e807970799caa68a19bfaa15135f165085e01d41a65ba1e1b146aeb6bd0092b49eac214c103ccfa3a365954bbbe52f74a2b3620c94", output.to_hex());
    }

    #[test]
    fn blake2b_512_salt_test() {
        let input = "hello".as_bytes();
        let mut output = [0u8; 64];
        let salt = [0u8, 1, 2];
        blake2b(null(), 0, salt.as_ptr(), salt.len() as u32, null(), 0, input.as_ptr(), input.len() as u32, output.as_mut_ptr(), output.len() as u32);
        assert_eq!("145f3c6814436c246f00e5f9ac50f8f651d134be36c51653330620e158aa006b78c5029c1d6025610796ddcaf6dd0b933367b3165749872b5c297af9a4000c9b", output.to_hex());
    }

    #[test]
    fn blake2s_256_test() {
        let input = "hello".as_bytes();
        let mut output = [0u8; 32];
        blake2s(null(), 0, null(), 0, null(), 0, input.as_ptr(), input.len() as u32, output.as_mut_ptr(), output.len() as u32);
        assert_eq!("19213bacc58dee6dbde3ceb9a47cbb330b3d86f8cca8997eb00be456f140ca25", output.to_hex());
    }
}