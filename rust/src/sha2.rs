use std::os::raw::c_char;

use crypto::digest::Digest;

use crate::util;

#[no_mangle]
pub extern fn sha224(input: *const c_char) -> *mut c_char {
    use crypto::sha2::Sha224;

    util::execute_block(input, |str| {
        let mut sh = Sha224::new();
        sh.input_str(str);
        sh.result_str()
    })
}

#[no_mangle]
pub extern fn sha256(input: *const c_char) -> *mut c_char {
    use crypto::sha2::Sha256;

    util::execute_block(input, |str| {
        let mut sh = Sha256::new();
        sh.input_str(str);
        sh.result_str()
    })
}

#[no_mangle]
pub extern fn sha384(input: *const c_char) -> *mut c_char {
    use crypto::sha2::Sha384;

    util::execute_block(input, |str| {
        let mut sh = Sha384::new();
        sh.input_str(str);
        sh.result_str()
    })
}

#[no_mangle]
pub extern fn sha512(input: *const c_char) -> *mut c_char {
    use crypto::sha2::Sha512;

    util::execute_block(input, |str| {
        let mut sh = Sha512::new();
        sh.input_str(str);
        sh.result_str()
    })
}

#[no_mangle]
pub extern fn sha512_trunc224(input: *const c_char) -> *mut c_char {
    use crypto::sha2::Sha512Trunc224;

    util::execute_block(input, |str| {
        let mut sh = Sha512Trunc224::new();
        sh.input_str(str);
        sh.result_str()
    })
}

#[no_mangle]
pub extern fn sha512_trunc256(input: *const c_char) -> *mut c_char {
    use crypto::sha2::Sha512Trunc256;

    util::execute_block(input, |str| {
        let mut sh = Sha512Trunc256::new();
        sh.input_str(str);
        sh.result_str()
    })
}

#[cfg(test)]
mod test {
    use std::ffi::CStr;
    use std::os::raw::c_char;

    use crate::sha2::{sha224, sha256, sha384, sha512, sha512_trunc224, sha512_trunc256};

    #[test]
    fn sha224_test() {
        let str = sha224(b"hello\0".as_ptr() as *const c_char);
        assert_eq!("ea09ae9cc6768c50fcee903ed054556e5bfc8347907f12598aa24193", unsafe { CStr::from_ptr(str) }.to_str().unwrap());
    }

    #[test]
    fn sha256_test() {
        let str = sha256(b"hello\0".as_ptr() as *const c_char);
        assert_eq!("2cf24dba5fb0a30e26e83b2ac5b9e29e1b161e5c1fa7425e73043362938b9824", unsafe { CStr::from_ptr(str) }.to_str().unwrap());
    }

    #[test]
    fn sha384_test() {
        let str = sha384(b"hello\0".as_ptr() as *const c_char);
        assert_eq!("59e1748777448c69de6b800d7a33bbfb9ff1b463e44354c3553bcdb9c666fa90125a3c79f90397bdf5f6a13de828684f", unsafe { CStr::from_ptr(str) }.to_str().unwrap());
    }

    #[test]
    fn sha512_test() {
        let str = sha512(b"hello\0".as_ptr() as *const c_char);
        assert_eq!("9b71d224bd62f3785d96d46ad3ea3d73319bfbc2890caadae2dff72519673ca72323c3d99ba5c11d7c7acc6e14b8c5da0c4663475c2e5c3adef46f73bcdec043", unsafe { CStr::from_ptr(str) }.to_str().unwrap());
    }

    #[test]
    fn sha512_trunc224_test() {
        let str = sha512_trunc224(b"hello\0".as_ptr() as *const c_char);
        assert_eq!("fe8509ed1fb7dcefc27e6ac1a80eddbec4cb3d2c6fe565244374061c", unsafe { CStr::from_ptr(str) }.to_str().unwrap());
    }

    #[test]
    fn sha512_trunc256_test() {
        let str = sha512_trunc256(b"hello\0".as_ptr() as *const c_char);
        assert_eq!("e30d87cfa2a75db545eac4d61baf970366a8357c7f72fa95b52d0accb698f13a", unsafe { CStr::from_ptr(str) }.to_str().unwrap());
    }
}