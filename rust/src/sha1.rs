use std::os::raw::c_char;

use crate::util;

#[no_mangle]
pub extern fn sha1(input: *const c_char) -> *mut c_char {
    use crypto::sha1::Sha1;
    use crypto::digest::Digest;

    let res = |str: &str| {
        let mut sh = Sha1::new();
        sh.input_str(str);
        sh.result_str()
    };

    util::execute_block(input, res)
}

#[cfg(test)]
mod test {
    use std::ffi::CStr;
    use std::os::raw::c_char;

    use crate::sha1::sha1;

    #[test]
    fn sha1_test() {
        let str = sha1(b"hello\0".as_ptr() as *const c_char);
        assert_eq!("aaf4c61ddcc5e8a2dabede0f3b482cd9aea9434d", unsafe { CStr::from_ptr(str) }.to_str().unwrap());
    }
}