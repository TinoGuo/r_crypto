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

static const uint32_t TYPE_GROESTL_224 = 70;

static const uint32_t TYPE_GROESTL_256 = 71;

static const uint32_t TYPE_GROESTL_384 = 72;

static const uint32_t TYPE_GROESTL_512 = 73;

static const uint32_t TYPE_GROESTL_BIG = 74;

static const uint32_t TYPE_GROESTL_SMALL = 75;

static const uint32_t TYPE_RIPEMD160 = 80;

static const uint32_t TYPE_SHABAL_192 = 90;

static const uint32_t TYPE_SHABAL_224 = 91;

static const uint32_t TYPE_SHABAL_256 = 92;

static const uint32_t TYPE_SHABAL_384 = 93;

static const uint32_t TYPE_SHABAL_512 = 94;

static const uint32_t TYPE_BLAKE2B = 100;

static const uint32_t TYPE_BLAKE2S = 101;

static const int32_t SUCCESS = 0;

static const int32_t PATH_INVALID = -1;

static const int32_t OPEN_FILE_FAILED = -2;

static const int32_t READ_FILE_FAILED = -3;

static const int32_t HASH_TYPE_INVALID = -4;

static const int32_t CREATE_HASH_FAILED = -5;

void rust_cstr_free(char *s);

int32_t hash_data(uint32_t hash_type,
                  const uint8_t *key,
                  uint32_t key_len,
                  const uint8_t *persona,
                  uint32_t persona_len,
                  const uint8_t *salt,
                  uint32_t salt_len,
                  const uint8_t *input,
                  uint32_t input_len,
                  uint8_t *output,
                  uint32_t output_len);

int32_t hash_file(uint32_t hash_type,
                  const uint8_t *key,
                  uint32_t key_len,
                  const uint8_t *persona,
                  uint32_t persona_len,
                  const uint8_t *salt,
                  uint32_t salt_len,
                  const char *input_path,
                  uint8_t *output,
                  uint32_t output_len);

