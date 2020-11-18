use std::ptr::null;

use criterion::{black_box, Criterion, criterion_group, criterion_main};

#[path = "../src/hash.rs"]
mod hash;
#[path = "../src/constants.rs"]
mod constants;

fn md5_bench(b: &mut Criterion) {
    let input = "hello".as_bytes();
    let mut output = [0u8; 16];
    b.bench_function("md5 bench", |b|
        b.iter(||
            hash::hash_data(0, null(), 0, input.as_ptr(), input.len() as u32, output.as_mut_ptr(), output.len() as u32)
        ),
    );
}

criterion_group!(benches, md5_bench);
criterion_main!(benches);