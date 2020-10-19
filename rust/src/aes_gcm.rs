use crypto::aead::AeadEncryptor;
use crypto::aes_gcm::AesGcm;
use std::os::raw::{c_uchar, c_uint};
use std::ptr::null_mut;
use std::slice;

#[no_mangle]
pub extern fn aes_gcm_new(
    key_p: *const c_uchar,
    len_key: c_uint,
    iv_p: *const c_uchar,
    len_iv: c_uint,
    add_p: *const c_uchar,
    len_add: c_uint,
) -> *mut AesGcm<'static> {
    use crypto::aes::KeySize::{KeySize128, KeySize192, KeySize256};

    if key_p.is_null() || iv_p.is_null() || add_p.is_null() {
        return null_mut();
    }

    // let key_size = match len_key {
    //     16 => KeySize128,
    //     24 => KeySize192,
    //     32 => KeySize256,
    //     _ => panic!()
    // };
    // let key: &[u8] = unsafe { slice::from_raw_parts(key_p, len_key as usize) };
    // let nonce: &[u8] = unsafe { slice::from_raw_parts(iv_p, len_iv as usize) };
    // let add: &[u8] = unsafe { slice::from_raw_parts(add_p, len_add as usize) };

    let a_key = vec![0u8; 32];
    let a_iv = vec![0u8; 12];
    let a_add = vec![0u8; 20];

    let obj = AesGcm::new(KeySize256, &a_key[..], &a_iv[..], &a_add[..]);
    let boxed = Box::new(obj);
    Box::into_raw(boxed)
}

#[no_mangle]
pub extern fn aes_gcm_encrypt(aes_gcm: *mut AesGcm<'static>,
                              input_p: *const c_uchar,
                              len_input: c_uint,
                              output_p: *mut c_uchar,
                              len_output: c_uint,
                              tag_p: *mut c_uchar,
                              len_tag: c_uint) {
    assert!(!aes_gcm.is_null() && !input_p.is_null() && !output_p.is_null() && !tag_p.is_null());
    let input: &[u8] = unsafe { slice::from_raw_parts(input_p, len_input as usize) };
    let output: &mut [u8] = unsafe { slice::from_raw_parts_mut(output_p, len_output as usize) };
    let tag: &mut [u8] = unsafe { slice::from_raw_parts_mut(tag_p, len_tag as usize) };
    let aes_gcm = unsafe { &mut *aes_gcm };
    aes_gcm.encrypt(input, output, tag);
}

#[no_mangle]
pub extern fn aes_gcm_destroy(aes_gcm: *mut AesGcm) {
    assert!(!aes_gcm.is_null());
    let boxed = unsafe { Box::from_raw(aes_gcm) };
    drop(boxed);
}

#[cfg(test)]
mod test {
    use rustc_serialize::hex::FromHex;
    use std::iter::repeat;

    use crate::aes_gcm::aes_gcm_new;

    #[test]
    fn aes_gcm_test() {
        let key = hex_to_bytes("feffe9928665731c6d6a8f9467308308");
        let iv = hex_to_bytes("cafebabefacedbaddecaf888");
        let add = hex_to_bytes("feedfacedeadbeeffeedfacedeadbeefabaddad2");

        let aes_gcm = aes_gcm_new(key.as_ptr(), 32, iv.as_ptr(), 12, add.as_ptr(), 20);
        let boxed = unsafe { Box::from_raw(aes_gcm) };
        drop(boxed);
    }

    fn hex_to_bytes(raw_hex: &str) -> Vec<u8> {
        raw_hex.from_hex().ok().unwrap()
    }
}
