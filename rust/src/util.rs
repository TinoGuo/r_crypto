use std::ffi::CString;
use std::os::raw::c_char;

// pub enum ProcessType {
//     Encrypt,
//     Decrypt,
// }

// pub fn execute_block<F>(input: *const c_char, f: F) -> *mut c_char where
//     F: FnOnce(&str) -> String {
//     let c_str = unsafe { CStr::from_ptr(input) };
//     let convert = c_str.to_str();
//     if convert.is_ok() {
//         let result_str = f(convert.unwrap());
//         CString::new(result_str).unwrap().into_raw()
//     } else {
//         null_mut()
//     }
// }

// pub fn execute_new_block<F>(input: *const c_char, f: F) -> *mut c_char where
//     F: FnOnce(&[u8]) -> Vec<u8> {
//     let c_str = unsafe { CStr::from_ptr(input) };
//     let convert = c_str.to_str();
//     if convert.is_ok() {
//         let u8_vec = f(convert.unwrap().as_bytes());
//         let str = u8_vec.to_hex();
//         let cstring = CString::new(str);
//         match cstring {
//             Ok(m) => m.into_raw(),
//             Err(_) => null_mut(),
//         }
//     } else {
//         null_mut()
//     }
// }

#[no_mangle]
pub extern "C" fn rust_cstr_free(s: *mut c_char) {
    unsafe {
        if s.is_null() {
            return;
        }
        CString::from_raw(s)
    };
}
