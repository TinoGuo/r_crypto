use std::io::{Read, Write};
use std::os::raw::c_char;
use std::result::Result::Ok;

use blake2::{VarBlake2b, VarBlake2s};
use digest::{Digest, ExtendableOutput, VariableOutput};
use groestl::{GroestlBig, GroestlSmall};
use sha3::{Shake128, Shake256};

use crate::error::*;
use std::borrow::BorrowMut;

macro_rules! hash_file_shake {
    ($hasher: ident, $reader: expr, $output: expr) => {{
        let mut sh = $hasher::default();
        match std::io::copy(&mut $reader, &mut sh) {
            Ok(_) => {
                let mut reader = sh.finalize_xof();
                match reader.read($output) {
                    Ok(_) => SUCCESS,
                    _ => READ_FILE_FAILED,
                }
            }
            _ => READ_FILE_FAILED,
        }
    }};
}

macro_rules! hash_file_groestl {
    ($hasher: ident, $reader: expr, $output: expr) => {{
        let len = $output.len();
        if let Ok(mut sh) = $hasher::new(len) {
            match std::io::copy(&mut $reader, &mut sh) {
                Ok(_) => {
                    sh.finalize_variable(|s| $output.copy_from_slice(s));
                    SUCCESS
                }
                _ => READ_FILE_FAILED,
            }
        } else {
            CREATE_HASH_FAILED
        }
    }};
}

macro_rules! hash_file_blake2 {
    ($blake: ident,
    $file: expr,
    $persona: expr,
    $persona_len: expr,
    $salt: expr,
    $salt_len: expr,
    $key: expr,
    $key_len: expr,
    $output: expr) => {{
        let persona = if !$persona.is_null() && $persona_len > 0 {
            unsafe { std::slice::from_raw_parts($persona, $persona_len as usize) }
        } else {
            &[]
        };
        let salt = if !$salt.is_null() && $salt_len > 0 {
            unsafe { std::slice::from_raw_parts($salt, $salt_len as usize) }
        } else {
            &[]
        };
        let key = if !$key.is_null() && $key_len > 0 {
            unsafe { std::slice::from_raw_parts($key, $key_len as usize) }
        } else {
            &[]
        };
        let mut blake2 = $blake::with_params(key, salt, persona, $output.len());
        let result = std::io::copy(&mut $file, &mut blake2);
        match result {
            Ok(_) => {
                blake2.finalize_variable(|res| $output.copy_from_slice(res));
                SUCCESS
            }
            _ => READ_FILE_FAILED,
        }
    }};
}

fn process<D: Digest + Default + Write, R: Read>(reader: &mut R, output: &mut [u8]) -> i32 {
    let mut sh = D::new();
    match std::io::copy(reader.borrow_mut(), &mut sh) {
        Ok(_) => {
            output.copy_from_slice(&sh.finalize());
            SUCCESS
        }
        _ => READ_FILE_FAILED,
    }
}

#[no_mangle]
pub extern "C" fn hash_file(
    hash_type: u32,
    key: *const u8,
    key_len: u32,
    persona: *const u8,
    persona_len: u32,
    salt: *const u8,
    salt_len: u32,
    input_path: *const c_char,
    output: *mut u8,
    output_len: u32,
) -> i32 {
    use crate::constants::*;

    let c_path = unsafe { std::ffi::CStr::from_ptr(input_path) };

    if let Ok(path) = c_path.to_str() {
        if let Ok(mut file) = std::fs::File::open(path) {
            let mut output = unsafe { std::slice::from_raw_parts_mut(output, output_len as usize) };
            let result = match hash_type {
                TYPE_MD5 => process::<md5::Md5, _>(&mut file, &mut output),
                TYPE_SHA1 => process::<sha1::Sha1, _>(&mut file, &mut output),
                TYPE_SHA224 => process::<sha2::Sha224, _>(&mut file, &mut output),
                TYPE_SHA256 => process::<sha2::Sha256, _>(&mut file, &mut output),
                TYPE_SHA384 => process::<sha2::Sha384, _>(&mut file, &mut output),
                TYPE_SHA512 => process::<sha2::Sha512, _>(&mut file, &mut output),
                TYPE_SHA512_TRUNC224 => process::<sha2::Sha512Trunc224, _>(&mut file, &mut output),
                TYPE_SHA512_TRUNC256 => process::<sha2::Sha512Trunc256, _>(&mut file, &mut output),
                TYPE_SHA3_224 => process::<sha3::Sha3_224, _>(&mut file, &mut output),
                TYPE_SHA3_256 => process::<sha3::Sha3_256, _>(&mut file, &mut output),
                TYPE_SHA3_384 => process::<sha3::Sha3_384, _>(&mut file, &mut output),
                TYPE_SHA3_512 => process::<sha3::Sha3_512, _>(&mut file, &mut output),
                TYPE_KECCAK_224 => process::<sha3::Keccak224, _>(&mut file, &mut output),
                TYPE_KECCAK_256 => process::<sha3::Keccak256, _>(&mut file, &mut output),
                TYPE_KECCAK_384 => process::<sha3::Keccak384, _>(&mut file, &mut output),
                TYPE_KECCAK_512 => process::<sha3::Keccak512, _>(&mut file, &mut output),
                TYPE_SHAKE_128 => hash_file_shake!(Shake128, file, output),
                TYPE_SHAKE_256 => hash_file_shake!(Shake256, file, output),
                TYPE_WHIRLPOOL => process::<whirlpool::Whirlpool, _>(&mut file, &mut output),
                TYPE_GROESTL_224 => process::<groestl::Groestl224, _>(&mut file, &mut output),
                TYPE_GROESTL_256 => process::<groestl::Groestl256, _>(&mut file, &mut output),
                TYPE_GROESTL_384 => process::<groestl::Groestl384, _>(&mut file, &mut output),
                TYPE_GROESTL_512 => process::<groestl::Groestl512, _>(&mut file, &mut output),
                TYPE_GROESTL_BIG => {
                    assert!(output_len > 32 && output_len <= 64);
                    hash_file_groestl!(GroestlBig, file, output)
                }
                TYPE_GROESTL_SMALL => {
                    assert!(output_len > 0 && output_len <= 32);
                    hash_file_groestl!(GroestlSmall, file, output)
                }
                TYPE_RIPEMD160 => process::<ripemd160::Ripemd160, _>(&mut file, &mut output),
                TYPE_SHABAL_192 => process::<shabal::Shabal192, _>(&mut file, &mut output),
                TYPE_SHABAL_224 => process::<shabal::Shabal224, _>(&mut file, &mut output),
                TYPE_SHABAL_256 => process::<shabal::Shabal256, _>(&mut file, &mut output),
                TYPE_SHABAL_384 => process::<shabal::Shabal384, _>(&mut file, &mut output),
                TYPE_SHABAL_512 => process::<shabal::Shabal512, _>(&mut file, &mut output),
                TYPE_BLAKE3 => {
                    let mut hasher = if !key.is_null() {
                        assert_eq!(key_len as usize, blake3::KEY_LEN);
                        let key = unsafe { std::slice::from_raw_parts(key, key_len as usize) };
                        let mut key32 = [0u8; blake3::KEY_LEN];
                        key32.copy_from_slice(key);
                        blake3::Hasher::new_keyed(&key32)
                    } else {
                        blake3::Hasher::default()
                    };
                    match std::io::copy(&mut file, &mut hasher) {
                        Ok(_) => {
                            let mut reader = hasher.finalize_xof();
                            reader.fill(output);
                            SUCCESS
                        }
                        _ => READ_FILE_FAILED,
                    }
                }
                TYPE_BLAKE2B => hash_file_blake2!(
                    VarBlake2b,
                    file,
                    key,
                    key_len,
                    persona,
                    persona_len,
                    salt,
                    salt_len,
                    output
                ),
                TYPE_BLAKE2S => hash_file_blake2!(
                    VarBlake2s,
                    file,
                    key,
                    key_len,
                    persona,
                    persona_len,
                    salt,
                    salt_len,
                    output
                ),
                _ => HASH_TYPE_INVALID,
            };
            result
        } else {
            OPEN_FILE_FAILED
        }
    } else {
        PATH_INVALID
    }
}

#[cfg(test)]
mod test_hash_file {
    use std::os::raw::c_char;
    use std::path::PathBuf;

    use rustc_serialize::hex::ToHex;

    use crate::constants::{
        TYPE_BLAKE2B, TYPE_BLAKE2S, TYPE_BLAKE3, TYPE_GROESTL_BIG, TYPE_MD5, TYPE_SHAKE_256,
    };
    use crate::hash_file::hash_file;
    use serial_test::serial;
    use std::ptr::null;

    macro_rules! simple_hash {
        ($type: expr, $path: expr, $key: expr, $key_len: expr, $persona: expr,$persona_len: expr,$salt: expr,$salt_len: expr, $output: expr, $output_len: expr) => {{
            hash_file(
                $type,
                $key,
                $key_len,
                $persona,
                $persona_len,
                $salt,
                $salt_len,
                $path,
                $output,
                $output_len,
            )
        }};
        ($type: expr, $path: expr, $key: expr, $key_len: expr, $output: expr, $output_len: expr) => {{
            hash_file(
                $type,
                $key,
                $key_len,
                null(),
                0u32,
                null(),
                0u32,
                $path,
                $output,
                $output_len,
            )
        }};
        ($type: expr, $path: expr, $output: expr, $output_len: expr) => {{
            hash_file(
                $type,
                null(),
                0u32,
                null(),
                0u32,
                null(),
                0u32,
                $path,
                $output,
                $output_len,
            )
        }};
    }

    macro_rules! test_path {
        ($name: expr) => {{
            let mut d = PathBuf::from(env!("CARGO_MANIFEST_DIR"));
            d.push(format!("tests/bin/{}\0", $name));
            let str = d.display().to_string();
            println!("out: {:?}", str);
            let bytes = str.as_bytes();
            bytes.to_vec()
        }};
    }

    #[test]
    #[serial]
    fn blake3_key_test() {
        let path_vec = test_path!("test_file.bin");
        println!("{:?}", path_vec);
        let path_ptr = path_vec.as_ptr() as *const c_char;
        let mut output = [0u8; 16];
        let key = [
            1u8, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0,
            1, 0, 1, 0,
        ];
        let error = simple_hash!(
            TYPE_BLAKE3,
            path_ptr,
            key.as_ptr(),
            key.len() as u32,
            output.as_mut_ptr(),
            output.len() as u32
        );
        assert_eq!(0, error);
        assert_eq!("044eabf8aa6bfbef0551ee70e12a92be", output.to_hex());
    }

    #[test]
    #[serial]
    fn blake3_test() {
        let path_vec = test_path!("test_file.bin");
        println!("{:?}", path_vec);
        let path_ptr = path_vec.as_ptr() as *const c_char;
        let mut output = [0u8; 16];
        let error = simple_hash!(
            TYPE_BLAKE3,
            path_ptr,
            output.as_mut_ptr(),
            output.len() as u32
        );
        assert_eq!(0, error);
        assert_eq!("75e674ae3dd00cf6d8ac6273a2c78430", output.to_hex());
    }

    #[test]
    #[serial]
    fn md5_test() {
        let path_vec = test_path!("test_file.bin");
        println!("{:?}", path_vec);
        let path_ptr = path_vec.as_ptr() as *const c_char;
        let mut output = [0u8; 16];
        let error = simple_hash!(TYPE_MD5, path_ptr, output.as_mut_ptr(), output.len() as u32);
        assert_eq!(0, error);
        assert_eq!("f1c9645dbc14efddc7d8a322685f26eb", output.to_hex());
    }

    #[test]
    #[serial]
    fn groestl_big_test() {
        let path_vec = test_path!("test_small_file.bin");
        println!("{:?}", path_vec);
        let path_ptr = path_vec.as_ptr() as *const c_char;
        let mut output = [0u8; 64];
        let error = simple_hash!(
            TYPE_GROESTL_BIG,
            path_ptr,
            output.as_mut_ptr(),
            output.len() as u32
        );
        assert_eq!(0, error);
        assert_eq!("e80d7b2bc33fc31b133a51875bfdc69d160d64db0810d8aeed7ebe3648368e08b543bac4ae4fafe073c8b560d6fe05c0b654ac2ce6f0c735e6d1ed786d343b4b", output.to_hex());
    }

    #[test]
    #[serial]
    fn shake256_test() {
        let path_vec = test_path!("test_file.bin");
        println!("{:?}", path_vec);
        let path_ptr = path_vec.as_ptr() as *const c_char;
        let mut output = [0u8; 64];
        let error = simple_hash!(
            TYPE_SHAKE_256,
            path_ptr,
            output.as_mut_ptr(),
            output.len() as u32
        );
        assert_eq!(0, error);
        assert_eq!("d2b786f09b0bee1ee6d5e4293098f013c010dac8f6a18bea62d70f58eb862c70fc66427a2c9aefa2702a006201c4fbcc9e5f3ff64fa2888fe30c67dc478c91c3", output.to_hex());
    }

    #[test]
    #[serial]
    fn blake2b_512_test() {
        let path_vec = test_path!("test_file.bin");
        println!("{:?}", path_vec);
        let path_ptr = path_vec.as_ptr() as *const c_char;
        let mut output = [0u8; 64];
        let error = simple_hash!(
            TYPE_BLAKE2B,
            path_ptr,
            output.as_mut_ptr(),
            output.len() as u32
        );
        assert_eq!(0, error);
        assert_eq!("c6c1c7f61eb77b5fb6e784d2090a160a5e8be5e18ea34660fae6ed402f089f08fb7705bba318349180ab9e4b93463fbb6d560d8e54520ce6bc3887489e9ef7c0", output.to_hex());
    }

    #[test]
    #[serial]
    fn blake2b_512_salt_test() {
        let path_vec = test_path!("test_file.bin");
        println!("{:?}", path_vec);
        let path_ptr = path_vec.as_ptr() as *const c_char;
        let mut output = [0u8; 64];
        let salt = [0u8, 1, 2];
        let error = simple_hash!(
            TYPE_BLAKE2B,
            path_ptr,
            null(),
            0u32,
            salt.as_ptr(),
            salt.len() as u32,
            null(),
            0u32,
            output.as_mut_ptr(),
            output.len() as u32
        );
        assert_eq!(0, error);
        assert_eq!("5a35225d95c881dad14d95083e4a585664ae086aa6e27e1d0f41d9cb507562a8ff6388fa3bcde8d251c87e55ac0f2d69c0e863e1bb62cda1385ade8740d1848a", output.to_hex());
    }

    #[test]
    #[serial]
    fn blake2s_256_test() {
        let path_vec = test_path!("test_file.bin");
        println!("{:?}", path_vec);
        let path_ptr = path_vec.as_ptr() as *const c_char;
        let mut output = [0u8; 32];
        let error = simple_hash!(
            TYPE_BLAKE2S,
            path_ptr,
            output.as_mut_ptr(),
            output.len() as u32
        );
        assert_eq!(0, error);
        assert_eq!(
            "263253cbc2688631ca3197d4b011ee9169cf27bc9f657f28786115f133743bf7",
            output.to_hex()
        );
    }
}
