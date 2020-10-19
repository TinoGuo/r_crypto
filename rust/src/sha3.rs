use std::os::raw::c_char;

use crypto::digest::Digest;

use crate::util;

#[no_mangle]
pub extern fn sha3_224(input: *const c_char) -> *mut c_char {
    use crypto::sha3::Sha3;

    util::execute_block(input, |str| {
        let mut sh = Sha3::sha3_224();
        sh.input_str(str);
        sh.result_str()
    })
}

#[no_mangle]
pub extern fn sha3_256(input: *const c_char) -> *mut c_char {
    use crypto::sha3::Sha3;

    util::execute_block(input, |str| {
        let mut sh = Sha3::sha3_256();
        sh.input_str(str);
        sh.result_str()
    })
}

#[no_mangle]
pub extern fn sha3_384(input: *const c_char) -> *mut c_char {
    use crypto::sha3::Sha3;

    util::execute_block(input, |str| {
        let mut sh = Sha3::sha3_384();
        sh.input_str(str);
        sh.result_str()
    })
}

#[no_mangle]
pub extern fn sha3_512(input: *const c_char) -> *mut c_char {
    use crypto::sha3::Sha3;

    util::execute_block(input, |str| {
        let mut sh = Sha3::sha3_512();
        sh.input_str(str);
        sh.result_str()
    })
}

#[no_mangle]
pub extern fn shake_128(input: *const c_char) -> *mut c_char {
    use crypto::sha3::Sha3;

    util::execute_block(input, |str| {
        let mut sh = Sha3::shake_128();
        sh.input_str(str);
        sh.result_str()
    })
}

#[no_mangle]
pub extern fn shake_256(input: *const c_char) -> *mut c_char {
    use crypto::sha3::Sha3;

    util::execute_block(input, |str| {
        let mut sh = Sha3::shake_256();
        sh.input_str(str);
        sh.result_str()
    })
}

#[no_mangle]
pub extern fn keccak224(input: *const c_char) -> *mut c_char {
    use crypto::sha3::Sha3;

    util::execute_block(input, |str| {
        let mut sh = Sha3::keccak224();
        sh.input_str(str);
        sh.result_str()
    })
}

#[no_mangle]
pub extern fn keccak256(input: *const c_char) -> *mut c_char {
    use crypto::sha3::Sha3;

    util::execute_block(input, |str| {
        let mut sh = Sha3::keccak256();
        sh.input_str(str);
        sh.result_str()
    })
}

#[no_mangle]
pub extern fn keccak384(input: *const c_char) -> *mut c_char {
    use crypto::sha3::Sha3;

    util::execute_block(input, |str| {
        let mut sh = Sha3::keccak384();
        sh.input_str(str);
        sh.result_str()
    })
}

#[no_mangle]
pub extern fn keccak512(input: *const c_char) -> *mut c_char {
    use crypto::sha3::Sha3;

    util::execute_block(input, |str| {
        let mut sh = Sha3::keccak512();
        sh.input_str(str);
        sh.result_str()
    })
}

#[cfg(test)]
mod test {
    use std::ffi::CStr;
    use std::os::raw::c_char;

    use crate::sha3::*;

    #[test]
    fn sha3_224_test() {
        let str = sha3_224(b"hello\0".as_ptr() as *const c_char);
        assert_eq!("b87f88c72702fff1748e58b87e9141a42c0dbedc29a78cb0d4a5cd81", unsafe { CStr::from_ptr(str) }.to_str().unwrap());
    }

    #[test]
    fn sha3_256_test() {
        let str = sha3_256(b"hello\0".as_ptr() as *const c_char);
        assert_eq!("3338be694f50c5f338814986cdf0686453a888b84f424d792af4b9202398f392", unsafe { CStr::from_ptr(str) }.to_str().unwrap());
    }

    #[test]
    fn sha3_384_test() {
        let str = sha3_384(b"hello\0".as_ptr() as *const c_char);
        assert_eq!("720aea11019ef06440fbf05d87aa24680a2153df3907b23631e7177ce620fa1330ff07c0fddee54699a4c3ee0ee9d887", unsafe { CStr::from_ptr(str) }.to_str().unwrap());
    }

    #[test]
    fn sha3_512_test() {
        let str = sha3_512(b"hello\0".as_ptr() as *const c_char);
        assert_eq!("75d527c368f2efe848ecf6b073a36767800805e9eef2b1857d5f984f036eb6df891d75f72d9b154518c1cd58835286d1da9a38deba3de98b5a53e5ed78a84976", unsafe { CStr::from_ptr(str) }.to_str().unwrap());
    }

    #[test]
    fn keccak224_test() {
        let str = keccak224(b"hello\0".as_ptr() as *const c_char);
        assert_eq!("45524ec454bcc7d4b8f74350c4a4e62809fcb49bc29df62e61b69fa4", unsafe { CStr::from_ptr(str) }.to_str().unwrap());
    }

    #[test]
    fn keccak256_test() {
        let str = keccak256(b"hello\0".as_ptr() as *const c_char);
        assert_eq!("1c8aff950685c2ed4bc3174f3472287b56d9517b9c948127319a09a7a36deac8", unsafe { CStr::from_ptr(str) }.to_str().unwrap());
    }

    #[test]
    fn keccak384_test() {
        let str = keccak384(b"hello\0".as_ptr() as *const c_char);
        assert_eq!("dcef6fb7908fd52ba26aaba75121526abbf1217f1c0a31024652d134d3e32fb4cd8e9c703b8f43e7277b59a5cd402175", unsafe { CStr::from_ptr(str) }.to_str().unwrap());
    }

    #[test]
    fn keccak512_test() {
        let str = keccak512(b"hello\0".as_ptr() as *const c_char);
        assert_eq!("52fa80662e64c128f8389c9ea6c73d4c02368004bf4463491900d11aaadca39d47de1b01361f207c512cfa79f0f92c3395c67ff7928e3f5ce3e3c852b392f976", unsafe { CStr::from_ptr(str) }.to_str().unwrap());
    }
}