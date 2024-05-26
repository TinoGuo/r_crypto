use criterion::{criterion_group, criterion_main, Criterion};

#[path = "../src/constants.rs"]
mod constants;
#[path = "../src/error.rs"]
mod error;
#[path = "../src/hash.rs"]
mod hash;

const INPUT: &[u8] = "hello".as_bytes();

macro_rules! hash_bench {
    ($name: expr, $type: expr, $len: expr, $c: expr) => {{
        use std::ptr::null;

        let mut output = [0u8; $len];
        $c.bench_function($name, |br| {
            br.iter(|| {
                hash::hash_data(
                    $type,
                    null(),
                    0,
                    null(),
                    0,
                    null(),
                    0,
                    INPUT.as_ptr(),
                    INPUT.len() as u32,
                    output.as_mut_ptr(),
                    output.len() as u32,
                )
            })
        });
    }};
}

fn md5_bench(b: &mut Criterion) {
    hash_bench!("md5", constants::TYPE_MD5, 16usize, b)
}

fn sha1_bench(b: &mut Criterion) {
    hash_bench!("sha1", constants::TYPE_SHA1, 20usize, b)
}

fn sha224_bench(b: &mut Criterion) {
    hash_bench!("sha224", constants::TYPE_SHA224, 28usize, b)
}

fn sha256_bench(b: &mut Criterion) {
    hash_bench!("sha256", constants::TYPE_SHA256, 32usize, b)
}

fn sha384_bench(b: &mut Criterion) {
    hash_bench!("sha384", constants::TYPE_SHA384, 48usize, b)
}

fn sha512_bench(b: &mut Criterion) {
    hash_bench!("sha512", constants::TYPE_SHA512, 64usize, b)
}

fn sha512_trunc224_bench(b: &mut Criterion) {
    hash_bench!(
        "sha512_trunc224",
        constants::TYPE_SHA512_TRUNC224,
        28usize,
        b
    )
}

fn sha512_trunc256_bench(b: &mut Criterion) {
    hash_bench!(
        "sha512_trunc256",
        constants::TYPE_SHA512_TRUNC256,
        32usize,
        b
    )
}

fn sha3_224_bench(b: &mut Criterion) {
    hash_bench!("sha3_224", constants::TYPE_SHA3_224, 28usize, b)
}

fn sha3_256_bench(b: &mut Criterion) {
    hash_bench!("sha3_256", constants::TYPE_SHA3_256, 32usize, b)
}

fn sha3_384_bench(b: &mut Criterion) {
    hash_bench!("sha3_384", constants::TYPE_SHA3_384, 48usize, b)
}

fn sha3_512_bench(b: &mut Criterion) {
    hash_bench!("sha3_512", constants::TYPE_SHA3_512, 64usize, b)
}

fn keccak_224_bench(b: &mut Criterion) {
    hash_bench!("keccak_224", constants::TYPE_KECCAK_224, 28usize, b)
}

fn keccak_256_bench(b: &mut Criterion) {
    hash_bench!("keccak_256", constants::TYPE_KECCAK_256, 32usize, b)
}

fn keccak_384_bench(b: &mut Criterion) {
    hash_bench!("keccak_384", constants::TYPE_KECCAK_384, 48usize, b)
}

fn keccak_512_bench(b: &mut Criterion) {
    hash_bench!("keccak_512", constants::TYPE_KECCAK_512, 64usize, b)
}

fn shake_128_bench(b: &mut Criterion) {
    hash_bench!("shake_128", constants::TYPE_SHAKE_128, 64usize, b)
}

fn shake_256_bench(b: &mut Criterion) {
    hash_bench!("shake_256", constants::TYPE_SHAKE_256, 64usize, b)
}

fn whirlpool_bench(b: &mut Criterion) {
    hash_bench!("whirlpool", constants::TYPE_WHIRLPOOL, 64usize, b)
}

fn blake3_256_bench(b: &mut Criterion) {
    hash_bench!("blake3_256", constants::TYPE_BLAKE3, 32usize, b)
}

fn blake3_512_bench(b: &mut Criterion) {
    hash_bench!("blake3_512", constants::TYPE_BLAKE3, 64usize, b)
}

fn groestl_224_bench(b: &mut Criterion) {
    hash_bench!("groestl_224", constants::TYPE_GROESTL_224, 28, b)
}

fn groestl_256_bench(b: &mut Criterion) {
    hash_bench!("groestl_256", constants::TYPE_GROESTL_256, 32, b)
}

fn groestl_384_bench(b: &mut Criterion) {
    hash_bench!("groestl_384", constants::TYPE_GROESTL_384, 48, b)
}

fn groestl_512_bench(b: &mut Criterion) {
    hash_bench!("groestl_512", constants::TYPE_GROESTL_512, 64, b)
}

fn groestl_big_bench(b: &mut Criterion) {
    hash_bench!("groestl_big", constants::TYPE_GROESTL_LONG, 64, b)
}

fn groestl_small_bench(b: &mut Criterion) {
    hash_bench!("groestl_small", constants::TYPE_GROESTL_SHORT, 32, b)
}

fn ripemd160_bench(b: &mut Criterion) {
    hash_bench!("ripemd160", constants::TYPE_RIPEMD160, 20, b)
}

fn shabal192_bench(b: &mut Criterion) {
    hash_bench!("shabal192", constants::TYPE_SHABAL_192, 24, b);
}

fn shabal224_bench(b: &mut Criterion) {
    hash_bench!("shabal224", constants::TYPE_SHABAL_224, 28, b);
}

fn shabal256_bench(b: &mut Criterion) {
    hash_bench!("shabal256", constants::TYPE_SHABAL_256, 32, b);
}

fn shabal384_bench(b: &mut Criterion) {
    hash_bench!("shabal384", constants::TYPE_SHABAL_384, 48, b);
}

fn shabal512_bench(b: &mut Criterion) {
    hash_bench!("shabal512", constants::TYPE_SHABAL_512, 64, b);
}

criterion_group!(
    benches,
    md5_bench,
    sha1_bench,
    sha224_bench,
    sha256_bench,
    sha384_bench,
    sha512_bench,
    sha512_trunc224_bench,
    sha512_trunc256_bench,
    sha3_224_bench,
    sha3_256_bench,
    sha3_384_bench,
    sha3_512_bench,
    keccak_224_bench,
    keccak_256_bench,
    keccak_384_bench,
    keccak_512_bench,
    shake_128_bench,
    shake_256_bench,
    whirlpool_bench,
    blake3_256_bench,
    blake3_512_bench,
    groestl_224_bench,
    groestl_256_bench,
    groestl_384_bench,
    groestl_512_bench,
    groestl_big_bench,
    groestl_small_bench,
    ripemd160_bench,
    shabal192_bench,
    shabal224_bench,
    shabal256_bench,
    sha384_bench,
    shabal512_bench
);
criterion_main!(benches);
