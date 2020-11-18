#import <Flutter/Flutter.h>

@interface RCryptoPlugin : NSObject<FlutterPlugin>
@end

static const uint32_t TYPE_MD5 = 0;

static const uint32_t TYPE_SHA1 = 10;

static const uint32_t TYPE_SHA224 = 20;

static const uint32_t TYPE_SHA256 = 21;

static const uint32_t TYPE_SHA384 = 22;

static const uint32_t TYPE_SHA512 = 23;

static const uint32_t TYPE_SHA512_TRUNC224 = 24;

static const uint32_t TYPE_SHA512_TRUNC256 = 25;

static const uint32_t TYPE_SHA3_224 = 30;

static const uint32_t TYPE_SHA3_256 = 31;

static const uint32_t TYPE_SHA3_384 = 32;

static const uint32_t TYPE_SHA3_512 = 33;

static const uint32_t TYPE_KECCAK_224 = 34;

static const uint32_t TYPE_KECCAK_256 = 35;

static const uint32_t TYPE_KECCAK_384 = 36;

static const uint32_t TYPE_KECCAK_512 = 37;

static const uint32_t TYPE_SHAKE_128 = 38;

static const uint32_t TYPE_SHAKE_256 = 39;

static const uint32_t TYPE_WHIRLPOOL = 50;

static const uint32_t TYPE_BLAKE3 = 60;

void rust_cstr_free(char *s);

void hash_data(uint32_t hash_type,
               const uint8_t *key,
               uint32_t key_len,
               const uint8_t *input,
               uint32_t input_len,
               uint8_t *output,
               uint32_t output_len);

void blake2b(const uint8_t *persona,
             uint32_t persona_len,
             const uint8_t *salt,
             uint32_t salt_len,
             const uint8_t *key,
             uint32_t key_len,
             const uint8_t *input,
             uint32_t input_len,
             uint8_t *output,
             uint32_t output_len);

void blake2s(const uint8_t *persona,
             uint32_t persona_len,
             const uint8_t *salt,
             uint32_t salt_len,
             const uint8_t *key,
             uint32_t key_len,
             const uint8_t *input,
             uint32_t input_len,
             uint8_t *output,
             uint32_t output_len);

