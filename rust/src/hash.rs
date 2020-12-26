use crate::error::*;

macro_rules! hash_data_fixed {
    ($hasher: ident, $input: expr, $input_len: expr, $output: expr, $output_len: expr, $expected_len: expr) => {{
        use std::slice;

        assert_eq!($output_len, $expected_len);
        let src = unsafe { slice::from_raw_parts($input, $input_len as usize) };
        let res = unsafe { slice::from_raw_parts_mut($output, $output_len as usize) };
        let s = $hasher::digest(src);
        res.copy_from_slice(&s);
        SUCCESS
    }};
}

macro_rules! hash_data_dynamic {
    ($x:expr, $y:expr, $z:expr) => {{
        $x.update($y);
        let mut reader = $x.finalize_xof();
        reader.read($z);
        SUCCESS
    }};
}

macro_rules! hash_data_blake2 {
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
    $output_len: expr) => {{
        use blake2::digest::Update;
        use blake2::digest::VariableOutput;

        assert!($output_len % 8 == 0);
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
        let input = unsafe { std::slice::from_raw_parts($input, $input_len as usize) };
        let result = unsafe { std::slice::from_raw_parts_mut($output, $output_len as usize) };
        let mut blake2 = $blake::with_params(key, salt, persona, $output_len as usize);
        blake2.update(input);
        blake2.finalize_variable(|res| result.copy_from_slice(res));
        SUCCESS
    }};
}

#[no_mangle]
pub extern "C" fn hash_data(
    hash_type: u32,
    key: *const u8,
    key_len: u32,
    persona: *const u8,
    persona_len: u32,
    salt: *const u8,
    salt_len: u32,
    input: *const u8,
    input_len: u32,
    output: *mut u8,
    output_len: u32,
) -> i32 {
    use crate::constants::*;
    use blake2::{VarBlake2b, VarBlake2s};
    use groestl::{Groestl224, Groestl256, Groestl384, Groestl512};
    use md5::Md5;
    use ripemd160::Ripemd160;
    use sha1::Sha1;
    use sha2::{Digest, Sha224, Sha256, Sha384, Sha512, Sha512Trunc224, Sha512Trunc256};
    use sha3::{
        Keccak224, Keccak256, Keccak384, Keccak512, Sha3_224, Sha3_256, Sha3_384, Sha3_512,
    };
    use shabal::{Shabal192, Shabal224, Shabal256, Shabal384, Shabal512};
    use whirlpool::Whirlpool;

    match hash_type {
        TYPE_MD5 => hash_data_fixed!(Md5, input, input_len, output, output_len, 16),
        TYPE_SHA1 => hash_data_fixed!(Sha1, input, input_len, output, output_len, 20),
        TYPE_SHA224 => hash_data_fixed!(Sha224, input, input_len, output, output_len, 28),
        TYPE_SHA256 => hash_data_fixed!(Sha256, input, input_len, output, output_len, 32),
        TYPE_SHA384 => hash_data_fixed!(Sha384, input, input_len, output, output_len, 48),
        TYPE_SHA512 => hash_data_fixed!(Sha512, input, input_len, output, output_len, 64),
        TYPE_SHA512_TRUNC224 => {
            hash_data_fixed!(Sha512Trunc224, input, input_len, output, output_len, 28)
        }
        TYPE_SHA512_TRUNC256 => {
            hash_data_fixed!(Sha512Trunc256, input, input_len, output, output_len, 32)
        }
        TYPE_SHA3_224 => hash_data_fixed!(Sha3_224, input, input_len, output, output_len, 28),
        TYPE_SHA3_256 => hash_data_fixed!(Sha3_256, input, input_len, output, output_len, 32),
        TYPE_SHA3_384 => hash_data_fixed!(Sha3_384, input, input_len, output, output_len, 48),
        TYPE_SHA3_512 => hash_data_fixed!(Sha3_512, input, input_len, output, output_len, 64),
        TYPE_KECCAK_224 => hash_data_fixed!(Keccak224, input, input_len, output, output_len, 28),
        TYPE_KECCAK_256 => hash_data_fixed!(Keccak256, input, input_len, output, output_len, 32),
        TYPE_KECCAK_384 => hash_data_fixed!(Keccak384, input, input_len, output, output_len, 48),
        TYPE_KECCAK_512 => hash_data_fixed!(Keccak512, input, input_len, output, output_len, 64),
        TYPE_WHIRLPOOL => hash_data_fixed!(Whirlpool, input, input_len, output, output_len, 64),
        TYPE_GROESTL_224 => hash_data_fixed!(Groestl224, input, input_len, output, output_len, 28),
        TYPE_GROESTL_256 => hash_data_fixed!(Groestl256, input, input_len, output, output_len, 32),
        TYPE_GROESTL_384 => hash_data_fixed!(Groestl384, input, input_len, output, output_len, 48),
        TYPE_GROESTL_512 => hash_data_fixed!(Groestl512, input, input_len, output, output_len, 64),
        TYPE_RIPEMD160 => hash_data_fixed!(Ripemd160, input, input_len, output, output_len, 20),
        TYPE_SHABAL_192 => hash_data_fixed!(Shabal192, input, input_len, output, output_len, 24),
        TYPE_SHABAL_224 => hash_data_fixed!(Shabal224, input, input_len, output, output_len, 28),
        TYPE_SHABAL_256 => hash_data_fixed!(Shabal256, input, input_len, output, output_len, 32),
        TYPE_SHABAL_384 => hash_data_fixed!(Shabal384, input, input_len, output, output_len, 48),
        TYPE_SHABAL_512 => hash_data_fixed!(Shabal512, input, input_len, output, output_len, 64),
        TYPE_BLAKE2B => hash_data_blake2!(
            VarBlake2b,
            persona,
            persona_len,
            salt,
            salt_len,
            key,
            key_len,
            input,
            input_len,
            output,
            output_len
        ),
        TYPE_BLAKE2S => hash_data_blake2!(
            VarBlake2s,
            persona,
            persona_len,
            salt,
            salt_len,
            key,
            key_len,
            input,
            input_len,
            output,
            output_len
        ),
        TYPE_SHAKE_128 => {
            use sha3::{
                digest::{ExtendableOutput, Update, XofReader},
                Shake128,
            };
            use std::slice;
            let src = unsafe { slice::from_raw_parts(input, input_len as usize) };
            let res = unsafe { slice::from_raw_parts_mut(output, output_len as usize) };
            let mut s = Shake128::default();
            hash_data_dynamic!(s, src, res)
        }
        TYPE_SHAKE_256 => {
            use sha3::{
                digest::{ExtendableOutput, Update, XofReader},
                Shake256,
            };
            use std::slice;
            let src = unsafe { slice::from_raw_parts(input, input_len as usize) };
            let res = unsafe { slice::from_raw_parts_mut(output, output_len as usize) };
            let mut s = Shake256::default();
            hash_data_dynamic!(s, src, res)
        }
        TYPE_BLAKE3 => {
            use blake3::Hasher;
            use std::slice;

            assert!(output_len > 0);
            let src = unsafe { slice::from_raw_parts(input, input_len as usize) };
            let res = unsafe { slice::from_raw_parts_mut(output, output_len as usize) };
            let mut hasher = if !key.is_null() {
                assert_eq!(key_len as usize, blake3::KEY_LEN);
                let key = unsafe { slice::from_raw_parts(key, key_len as usize) };
                let mut key32 = [0u8; blake3::KEY_LEN];
                key32.copy_from_slice(key);
                Hasher::new_keyed(&key32)
            } else {
                Hasher::default()
            };
            hasher.update(src);
            let mut output = hasher.finalize_xof();
            output.fill(res);
            SUCCESS
        }
        TYPE_GROESTL_BIG => {
            use groestl::digest::Update;
            use groestl::digest::VariableOutput;
            assert!(output_len > 32 && output_len <= 64);
            let src = unsafe { std::slice::from_raw_parts(input, input_len as usize) };
            let res = unsafe { std::slice::from_raw_parts_mut(output, output_len as usize) };
            let mut hasher = groestl::GroestlBig::new(output_len as usize).unwrap();
            hasher.update(src);
            hasher.finalize_variable(|s| res.copy_from_slice(s));
            SUCCESS
        }
        TYPE_GROESTL_SMALL => {
            use groestl::digest::Update;
            use groestl::digest::VariableOutput;
            assert!(output_len > 0 && output_len <= 32);
            let src = unsafe { std::slice::from_raw_parts(input, input_len as usize) };
            let res = unsafe { std::slice::from_raw_parts_mut(output, output_len as usize) };
            let mut hasher = groestl::GroestlSmall::new(output_len as usize).unwrap();
            hasher.update(src);
            hasher.finalize_variable(|s| res.copy_from_slice(s));
            SUCCESS
        }
        _ => HASH_TYPE_INVALID,
    }
}

#[cfg(test)]
mod test_hash {
    use std::ptr::null;

    use rustc_serialize::hex::ToHex;

    use crate::constants::*;
    use crate::hash::*;

    macro_rules! simple_hash {
        ($type: expr, $key: expr, $key_len: expr, $persona: expr,$persona_len: expr,$salt: expr,$salt_len: expr, $input: expr, $input_len: expr, $output: expr, $output_len: expr) => {{
            hash_data(
                $type,
                $key,
                $key_len,
                $persona,
                $persona_len,
                $salt,
                $salt_len,
                $input,
                $input_len,
                $output,
                $output_len,
            )
        }};
        ($type: expr, $key: expr, $key_len: expr,  $input: expr, $input_len: expr,$output: expr, $output_len: expr) => {{
            hash_data(
                $type,
                $key,
                $key_len,
                null(),
                0u32,
                null(),
                0u32,
                $input,
                $input_len,
                $output,
                $output_len,
            )
        }};
        ($type: expr,  $input: expr, $input_len: expr, $output: expr, $output_len: expr) => {{
            hash_data(
                $type,
                null(),
                0u32,
                null(),
                0u32,
                null(),
                0u32,
                $input,
                $input_len,
                $output,
                $output_len,
            )
        }};
    }

    #[test]
    fn md5_test() {
        let input = "hello world".as_bytes();
        let mut output = [0u8; 16];
        let result = simple_hash!(
            TYPE_MD5,
            input.as_ptr(),
            input.len() as u32,
            output.as_mut_ptr(),
            output.len() as u32
        );
        assert_eq!(0, result);
        assert_eq!("5eb63bbbe01eeed093cb22bb8f5acdc3", output.to_hex());
    }

    #[test]
    fn sha1_test() {
        let input = "hello".as_bytes();
        let mut output = [0u8; 20];
        let result = simple_hash!(
            TYPE_SHA1,
            input.as_ptr(),
            input.len() as u32,
            output.as_mut_ptr(),
            output.len() as u32
        );
        assert_eq!(0, result);
        assert_eq!("aaf4c61ddcc5e8a2dabede0f3b482cd9aea9434d", output.to_hex());
    }

    #[test]
    fn sha224_test() {
        let input = "hello".as_bytes();
        let mut output = [0u8; 28];
        let result = simple_hash!(
            TYPE_SHA224,
            input.as_ptr(),
            input.len() as u32,
            output.as_mut_ptr(),
            output.len() as u32
        );
        assert_eq!(0, result);
        assert_eq!(
            "ea09ae9cc6768c50fcee903ed054556e5bfc8347907f12598aa24193",
            output.to_hex()
        );
    }

    #[test]
    fn sha256_test() {
        let input = "hello".as_bytes();
        let mut output = [0u8; 32];
        let result = simple_hash!(
            TYPE_SHA256,
            input.as_ptr(),
            input.len() as u32,
            output.as_mut_ptr(),
            output.len() as u32
        );
        assert_eq!(0, result);
        assert_eq!(
            "2cf24dba5fb0a30e26e83b2ac5b9e29e1b161e5c1fa7425e73043362938b9824",
            output.to_hex()
        );
    }

    #[test]
    fn sha384_test() {
        let input = "hello".as_bytes();
        let mut output = [0u8; 48];
        let result = simple_hash!(
            TYPE_SHA384,
            input.as_ptr(),
            input.len() as u32,
            output.as_mut_ptr(),
            output.len() as u32
        );
        assert_eq!(0, result);
        assert_eq!("59e1748777448c69de6b800d7a33bbfb9ff1b463e44354c3553bcdb9c666fa90125a3c79f90397bdf5f6a13de828684f", output.to_hex());
    }

    #[test]
    fn sha512_test() {
        let input = "hello".as_bytes();
        let mut output = [0u8; 64];
        let result = simple_hash!(
            TYPE_SHA512,
            input.as_ptr(),
            input.len() as u32,
            output.as_mut_ptr(),
            output.len() as u32
        );
        assert_eq!(0, result);
        assert_eq!("9b71d224bd62f3785d96d46ad3ea3d73319bfbc2890caadae2dff72519673ca72323c3d99ba5c11d7c7acc6e14b8c5da0c4663475c2e5c3adef46f73bcdec043", output.to_hex());
    }

    #[test]
    fn sha512_trunc224_test() {
        let input = "hello".as_bytes();
        let mut output = [0u8; 28];
        let result = simple_hash!(
            TYPE_SHA512_TRUNC224,
            input.as_ptr(),
            input.len() as u32,
            output.as_mut_ptr(),
            output.len() as u32
        );
        assert_eq!(0, result);
        assert_eq!(
            "fe8509ed1fb7dcefc27e6ac1a80eddbec4cb3d2c6fe565244374061c",
            output.to_hex()
        );
    }

    #[test]
    fn sha512_trunc256_test() {
        let input = "hello".as_bytes();
        let mut output = [0u8; 32];
        let result = simple_hash!(
            TYPE_SHA512_TRUNC256,
            input.as_ptr(),
            input.len() as u32,
            output.as_mut_ptr(),
            output.len() as u32
        );
        assert_eq!(0, result);
        assert_eq!(
            "e30d87cfa2a75db545eac4d61baf970366a8357c7f72fa95b52d0accb698f13a",
            output.to_hex()
        );
    }

    #[test]
    fn sha3_224_test() {
        let input = "hello".as_bytes();
        let mut output = [0u8; 28];
        let result = simple_hash!(
            TYPE_SHA3_224,
            input.as_ptr(),
            input.len() as u32,
            output.as_mut_ptr(),
            output.len() as u32
        );
        assert_eq!(0, result);
        assert_eq!(
            "b87f88c72702fff1748e58b87e9141a42c0dbedc29a78cb0d4a5cd81",
            output.to_hex()
        );
    }

    #[test]
    fn sha3_256_test() {
        let input = "hello".as_bytes();
        let mut output = [0u8; 32];
        let result = simple_hash!(
            TYPE_SHA3_256,
            input.as_ptr(),
            input.len() as u32,
            output.as_mut_ptr(),
            output.len() as u32
        );
        assert_eq!(0, result);
        assert_eq!(
            "3338be694f50c5f338814986cdf0686453a888b84f424d792af4b9202398f392",
            output.to_hex()
        );
    }

    #[test]
    fn sha3_384_test() {
        let input = "hello".as_bytes();
        let mut output = [0u8; 48];
        let result = simple_hash!(
            TYPE_SHA3_384,
            input.as_ptr(),
            input.len() as u32,
            output.as_mut_ptr(),
            output.len() as u32
        );
        assert_eq!(0, result);
        assert_eq!("720aea11019ef06440fbf05d87aa24680a2153df3907b23631e7177ce620fa1330ff07c0fddee54699a4c3ee0ee9d887", output.to_hex());
    }

    #[test]
    fn sha3_512_test() {
        let input = "hello".as_bytes();
        let mut output = [0u8; 64];
        let result = simple_hash!(
            TYPE_SHA3_512,
            input.as_ptr(),
            input.len() as u32,
            output.as_mut_ptr(),
            output.len() as u32
        );
        assert_eq!(0, result);
        assert_eq!("75d527c368f2efe848ecf6b073a36767800805e9eef2b1857d5f984f036eb6df891d75f72d9b154518c1cd58835286d1da9a38deba3de98b5a53e5ed78a84976", output.to_hex());
    }

    #[test]
    fn keccak_224_test() {
        let input = "hello".as_bytes();
        let mut output = [0u8; 28];
        let result = simple_hash!(
            TYPE_KECCAK_224,
            input.as_ptr(),
            input.len() as u32,
            output.as_mut_ptr(),
            output.len() as u32
        );
        assert_eq!(0, result);
        assert_eq!(
            "45524ec454bcc7d4b8f74350c4a4e62809fcb49bc29df62e61b69fa4",
            output.to_hex()
        );
    }

    #[test]
    fn keccak_256_test() {
        let input = "hello".as_bytes();
        let mut output = [0u8; 32];
        let result = simple_hash!(
            TYPE_KECCAK_256,
            input.as_ptr(),
            input.len() as u32,
            output.as_mut_ptr(),
            output.len() as u32
        );
        assert_eq!(0, result);
        assert_eq!(
            "1c8aff950685c2ed4bc3174f3472287b56d9517b9c948127319a09a7a36deac8",
            output.to_hex()
        );
    }

    #[test]
    fn keccak_384_test() {
        let input = "hello".as_bytes();
        let mut output = [0u8; 48];
        let result = simple_hash!(
            TYPE_KECCAK_384,
            input.as_ptr(),
            input.len() as u32,
            output.as_mut_ptr(),
            output.len() as u32
        );
        assert_eq!(0, result);
        assert_eq!("dcef6fb7908fd52ba26aaba75121526abbf1217f1c0a31024652d134d3e32fb4cd8e9c703b8f43e7277b59a5cd402175", output.to_hex());
    }

    #[test]
    fn keccak_512_test() {
        let input = "hello".as_bytes();
        let mut output = [0u8; 64];
        let result = simple_hash!(
            TYPE_KECCAK_512,
            input.as_ptr(),
            input.len() as u32,
            output.as_mut_ptr(),
            output.len() as u32
        );
        assert_eq!(0, result);
        assert_eq!("52fa80662e64c128f8389c9ea6c73d4c02368004bf4463491900d11aaadca39d47de1b01361f207c512cfa79f0f92c3395c67ff7928e3f5ce3e3c852b392f976", output.to_hex());
    }

    #[test]
    fn shake_128_test() {
        let input = "hello".as_bytes();
        let mut output = [0u8; 10];
        let result = simple_hash!(
            TYPE_SHAKE_128,
            input.as_ptr(),
            input.len() as u32,
            output.as_mut_ptr(),
            output.len() as u32
        );
        assert_eq!(0, result);
        assert_eq!("8eb4b6a932f280335ee1", output.to_hex());
    }

    #[test]
    fn shake_256_test() {
        let input = "hello".as_bytes();
        let mut output = [0u8; 64];
        let result = simple_hash!(
            TYPE_SHAKE_256,
            input.as_ptr(),
            input.len() as u32,
            output.as_mut_ptr(),
            output.len() as u32
        );
        assert_eq!(0, result);
        assert_eq!("1234075ae4a1e77316cf2d8000974581a343b9ebbca7e3d1db83394c30f221626f594e4f0de63902349a5ea5781213215813919f92a4d86d127466e3d07e8be3", output.to_hex());
    }

    #[test]
    fn whirlpool_test() {
        let input = "hello".as_bytes();
        let mut output = [0u8; 64];
        let result = simple_hash!(
            TYPE_WHIRLPOOL,
            input.as_ptr(),
            input.len() as u32,
            output.as_mut_ptr(),
            output.len() as u32
        );
        assert_eq!(0, result);
        assert_eq!("0a25f55d7308eca6b9567a7ed3bd1b46327f0f1ffdc804dd8bb5af40e88d78b88df0d002a89e2fdbd5876c523f1b67bc44e9f87047598e7548298ea1c81cfd73", output.to_hex());
    }

    #[test]
    fn blake3_256_test() {
        let input = "hello".as_bytes();
        let mut output = [0u8; 32];
        let result = simple_hash!(
            TYPE_BLAKE3,
            input.as_ptr(),
            input.len() as u32,
            output.as_mut_ptr(),
            output.len() as u32
        );
        assert_eq!(0, result);
        assert_eq!(
            "ea8f163db38682925e4491c5e58d4bb3506ef8c14eb78a86e908c5624a67200f",
            output.to_hex()
        );
    }

    #[test]
    fn blake3_512_test() {
        let input = "hello".as_bytes();
        let mut output = [0u8; 64];
        let result = simple_hash!(
            TYPE_BLAKE3,
            input.as_ptr(),
            input.len() as u32,
            output.as_mut_ptr(),
            output.len() as u32
        );
        assert_eq!(0, result);
        assert_eq!("ea8f163db38682925e4491c5e58d4bb3506ef8c14eb78a86e908c5624a67200fe992405f0d785b599a2e3387f6d34d01faccfeb22fb697ef3fd53541241a338c", output.to_hex());
    }

    #[test]
    fn blake3_256_key_test() {
        let input = "hello".as_bytes();
        let mut output = [0u8; 32];
        let key = b"01234567890123456789012345678901";
        let result = simple_hash!(
            TYPE_BLAKE3,
            key.as_ptr(),
            key.len() as u32,
            input.as_ptr(),
            input.len() as u32,
            output.as_mut_ptr(),
            output.len() as u32
        );
        assert_eq!(0, result);
        assert_eq!(
            "a90d00da3185ee3b0212f04238f9fad58199dc63ab71c5f1968d9b03d681919b",
            output.to_hex()
        );
    }

    #[test]
    fn groestl_224_test() {
        let input = "".as_bytes();
        let mut output = [0u8; 28];
        let result = simple_hash!(
            TYPE_GROESTL_224,
            input.as_ptr(),
            input.len() as u32,
            output.as_mut_ptr(),
            output.len() as u32
        );
        assert_eq!(0, result);
        assert_eq!(
            "f2e180fb5947be964cd584e22e496242c6a329c577fc4ce8c36d34c3",
            output.to_hex()
        );
    }

    #[test]
    fn groestl_256_test() {
        let input = "".as_bytes();
        let mut output = [0u8; 32];
        let result = simple_hash!(
            TYPE_GROESTL_256,
            input.as_ptr(),
            input.len() as u32,
            output.as_mut_ptr(),
            output.len() as u32
        );
        assert_eq!(0, result);
        assert_eq!(
            "1a52d11d550039be16107f9c58db9ebcc417f16f736adb2502567119f0083467",
            output.to_hex()
        );
    }

    #[test]
    fn groestl_384_test() {
        let input = "".as_bytes();
        let mut output = [0u8; 48];
        let result = simple_hash!(
            TYPE_GROESTL_384,
            input.as_ptr(),
            input.len() as u32,
            output.as_mut_ptr(),
            output.len() as u32
        );
        assert_eq!(0, result);
        assert_eq!("ac353c1095ace21439251007862d6c62f829ddbe6de4f78e68d310a9205a736d8b11d99bffe448f57a1cfa2934f044a5", output.to_hex());
    }

    #[test]
    fn groestl_512_test() {
        let input = "".as_bytes();
        let mut output = [0u8; 64];
        let result = simple_hash!(
            TYPE_GROESTL_512,
            input.as_ptr(),
            input.len() as u32,
            output.as_mut_ptr(),
            output.len() as u32
        );
        assert_eq!(0, result);
        assert_eq!("6d3ad29d279110eef3adbd66de2a0345a77baede1557f5d099fce0c03d6dc2ba8e6d4a6633dfbd66053c20faa87d1a11f39a7fbe4a6c2f009801370308fc4ad8", output.to_hex());
    }

    #[test]
    #[should_panic]
    fn groestl_big_size_equal_min_test() {
        let input = "".as_bytes();
        let mut output = [0u8; 32];
        let result = simple_hash!(
            TYPE_GROESTL_BIG,
            input.as_ptr(),
            input.len() as u32,
            output.as_mut_ptr(),
            output.len() as u32
        );
        assert_eq!(0, result);
        assert_eq!("6d3ad29d279110eef3adbd66de2a0345a77baede1557f5d099fce0c03d6dc2ba8e6d4a6633dfbd66053c20faa87d1a11f39a7fbe4a6c2f009801370308fc4ad8", output.to_hex());
    }

    #[test]
    #[should_panic]
    fn groestl_big_size_larger_max_test() {
        let input = "".as_bytes();
        let mut output = [0u8; 65];
        let result = simple_hash!(
            TYPE_GROESTL_BIG,
            input.as_ptr(),
            input.len() as u32,
            output.as_mut_ptr(),
            output.len() as u32
        );
        assert_eq!(0, result);
        assert_eq!("6d3ad29d279110eef3adbd66de2a0345a77baede1557f5d099fce0c03d6dc2ba8e6d4a6633dfbd66053c20faa87d1a11f39a7fbe4a6c2f009801370308fc4ad8", output.to_hex());
    }

    #[test]
    fn groestl_big_test() {
        let input = "".as_bytes();
        let mut output = [0u8; 64];
        let result = simple_hash!(
            TYPE_GROESTL_BIG,
            input.as_ptr(),
            input.len() as u32,
            output.as_mut_ptr(),
            output.len() as u32
        );
        assert_eq!(0, result);
        assert_eq!("6d3ad29d279110eef3adbd66de2a0345a77baede1557f5d099fce0c03d6dc2ba8e6d4a6633dfbd66053c20faa87d1a11f39a7fbe4a6c2f009801370308fc4ad8", output.to_hex());
    }

    #[test]
    #[should_panic]
    fn groestl_small_size_equal_min_test() {
        let input = "".as_bytes();
        let mut output = [0u8; 0];
        let result = simple_hash!(
            TYPE_GROESTL_SMALL,
            input.as_ptr(),
            input.len() as u32,
            output.as_mut_ptr(),
            output.len() as u32
        );
        assert_eq!(0, result);
        assert_eq!("6d3ad29d279110eef3adbd66de2a0345a77baede1557f5d099fce0c03d6dc2ba8e6d4a6633dfbd66053c20faa87d1a11f39a7fbe4a6c2f009801370308fc4ad8", output.to_hex());
    }

    #[test]
    #[should_panic]
    fn groestl_small_size_larger_max_test() {
        let input = "".as_bytes();
        let mut output = [0u8; 33];
        let result = simple_hash!(
            TYPE_GROESTL_SMALL,
            input.as_ptr(),
            input.len() as u32,
            output.as_mut_ptr(),
            output.len() as u32
        );
        assert_eq!(0, result);
        assert_eq!("6d3ad29d279110eef3adbd66de2a0345a77baede1557f5d099fce0c03d6dc2ba8e6d4a6633dfbd66053c20faa87d1a11f39a7fbe4a6c2f009801370308fc4ad8", output.to_hex());
    }

    #[test]
    fn groestl_small_test() {
        let input = "".as_bytes();
        let mut output = [0u8; 32];
        let result = simple_hash!(
            TYPE_GROESTL_SMALL,
            input.as_ptr(),
            input.len() as u32,
            output.as_mut_ptr(),
            output.len() as u32
        );
        assert_eq!(0, result);
        assert_eq!(
            "1a52d11d550039be16107f9c58db9ebcc417f16f736adb2502567119f0083467",
            output.to_hex()
        );
    }

    #[test]
    fn ripemd160_test() {
        let input = "hello".as_bytes();
        let mut output = [0u8; 20];
        let result = simple_hash!(
            TYPE_RIPEMD160,
            input.as_ptr(),
            input.len() as u32,
            output.as_mut_ptr(),
            output.len() as u32
        );
        assert_eq!(0, result);
        assert_eq!("108f07b8382412612c048d07d13f814118445acd", output.to_hex());
    }

    #[test]
    fn shabal192_test() {
        let input = "hello".as_bytes();
        let mut output = [0u8; 24];
        let result = simple_hash!(
            TYPE_SHABAL_192,
            input.as_ptr(),
            input.len() as u32,
            output.as_mut_ptr(),
            output.len() as u32
        );
        assert_eq!(0, result);
        assert_eq!(
            "f7303fed54ee00d610c136da488edf5dbfe75f3188dace41",
            output.to_hex()
        );
    }

    #[test]
    fn shabal224_test() {
        let input = "hello".as_bytes();
        let mut output = [0u8; 28];
        let result = simple_hash!(
            TYPE_SHABAL_224,
            input.as_ptr(),
            input.len() as u32,
            output.as_mut_ptr(),
            output.len() as u32
        );
        assert_eq!(0, result);
        assert_eq!(
            "a0f6a2410c1a6f12dcc98767e9ecbfb5e49e4fe82cb5d29029571e5f",
            output.to_hex()
        );
    }

    #[test]
    fn shabal256_test() {
        let input = "hello".as_bytes();
        let mut output = [0u8; 32];
        let result = simple_hash!(
            TYPE_SHABAL_256,
            input.as_ptr(),
            input.len() as u32,
            output.as_mut_ptr(),
            output.len() as u32
        );
        assert_eq!(0, result);
        assert_eq!(
            "6563a2d36f2f541e38aaa3f5375bfae8ce1dd2811cdf0993216669d48618aa9a",
            output.to_hex()
        );
    }

    #[test]
    fn shabal384_test() {
        let input = "hello".as_bytes();
        let mut output = [0u8; 48];
        let result = simple_hash!(
            TYPE_SHABAL_384,
            input.as_ptr(),
            input.len() as u32,
            output.as_mut_ptr(),
            output.len() as u32
        );
        assert_eq!(0, result);
        assert_eq!("ff2e07970744daa5558544ed6d3c6f56e6246ec168439dc155cfd19d38dff67762131843990a4c66af33ab12544ff952", output.to_hex());
    }

    #[test]
    fn shabal512_test() {
        let input = "hello".as_bytes();
        let mut output = [0u8; 64];
        let result = simple_hash!(
            TYPE_SHABAL_512,
            input.as_ptr(),
            input.len() as u32,
            output.as_mut_ptr(),
            output.len() as u32
        );
        assert_eq!(0, result);
        assert_eq!("960314edd29daaaf71e2637f50a221201bf8d6a7f2fbd6487b306ea47f5aa70a122e9e7a23221fa97480e723ac2b3aa2786937ea44aa6fdefa1daebe4b27fbbc", output.to_hex());
    }

    #[test]
    fn blake2b_512_test() {
        let input = "hello".as_bytes();
        let mut output = [0u8; 64];
        let result = simple_hash!(
            TYPE_BLAKE2B,
            input.as_ptr(),
            input.len() as u32,
            output.as_mut_ptr(),
            output.len() as u32
        );
        assert_eq!(0, result);
        assert_eq!("e4cfa39a3d37be31c59609e807970799caa68a19bfaa15135f165085e01d41a65ba1e1b146aeb6bd0092b49eac214c103ccfa3a365954bbbe52f74a2b3620c94", output.to_hex());
    }

    #[test]
    fn blake2b_512_salt_test() {
        let input = "hello".as_bytes();
        let mut output = [0u8; 64];
        let salt = [0u8, 1, 2];
        let result = simple_hash!(
            TYPE_BLAKE2B,
            null(),
            0,
            null(),
            0,
            salt.as_ptr(),
            salt.len() as u32,
            input.as_ptr(),
            input.len() as u32,
            output.as_mut_ptr(),
            output.len() as u32
        );
        assert_eq!(0, result);
        assert_eq!("145f3c6814436c246f00e5f9ac50f8f651d134be36c51653330620e158aa006b78c5029c1d6025610796ddcaf6dd0b933367b3165749872b5c297af9a4000c9b", output.to_hex());
    }

    #[test]
    fn blake2s_256_test() {
        let input = "hello".as_bytes();
        let mut output = [0u8; 32];
        let result = simple_hash!(
            TYPE_BLAKE2S,
            input.as_ptr(),
            input.len() as u32,
            output.as_mut_ptr(),
            output.len() as u32
        );
        assert_eq!(0, result);
        assert_eq!(
            "19213bacc58dee6dbde3ceb9a47cbb330b3d86f8cca8997eb00be456f140ca25",
            output.to_hex()
        );
    }

    #[test]
    #[should_panic]
    fn blake2s_256_panic_test() {
        let input = "hello".as_bytes();
        let mut output = [0u8; 33];
        simple_hash!(
            TYPE_BLAKE2S,
            input.as_ptr(),
            input.len() as u32,
            output.as_mut_ptr(),
            output.len() as u32
        );
    }
}
