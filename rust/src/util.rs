use std::ffi::{CStr, CString};
use std::os::raw::c_char;
use std::ptr::null_mut;

pub enum ProcessType {
    Encrypt,
    Decrypt,
}

pub fn execute_block<F>(input: *const c_char, f: F) -> *mut c_char where
    F: FnOnce(&str) -> String {
    let c_str = unsafe { CStr::from_ptr(input) };
    let convert = c_str.to_str();
    if convert.is_ok() {
        let result_str = f(convert.unwrap());
        CString::new(result_str).unwrap().into_raw()
    } else {
        null_mut()
    }
}

#[no_mangle]
pub extern fn rust_cstr_free(s: *mut c_char) {
    unsafe {
        if s.is_null() { return; }
        CString::from_raw(s)
    };
}