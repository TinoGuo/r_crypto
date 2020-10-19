use std::os::raw::c_char;

use crypto::digest::Digest;

use crate::util;

#[no_mangle]
pub extern fn md5(input: *const c_char) -> *mut c_char {
    use crypto::md5::Md5;

    util::execute_block(input, |str| {
        let mut sh = Md5::new();
        sh.input_str(str);
        sh.result_str()
    })
}

#[cfg(test)]
mod test {
    use std::ffi::CStr;
    use std::os::raw::c_char;

    use crate::md5::md5;

    #[test]
    fn md5_test() {
        let str = md5(b"hello\0".as_ptr() as *const c_char);
        assert_eq!("5d41402abc4b2a76b9719d911017c592", unsafe { CStr::from_ptr(str) }.to_str().unwrap());
    }
}
