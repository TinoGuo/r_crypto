#import <Flutter/Flutter.h>

@interface RCryptoPlugin : NSObject<FlutterPlugin>
@end

char *keccak224(const char *input);

char *keccak256(const char *input);

char *keccak384(const char *input);

char *keccak512(const char *input);

char *md5(const char *input);

void rust_cstr_free(char *s);

char *sha1(const char *input);

char *sha224(const char *input);

char *sha256(const char *input);

char *sha384(const char *input);

char *sha3_224(const char *input);

char *sha3_256(const char *input);

char *sha3_384(const char *input);

char *sha3_512(const char *input);

char *sha512(const char *input);

char *sha512_trunc224(const char *input);

char *sha512_trunc256(const char *input);

char *shake_128(const char *input);

char *shake_256(const char *input);

char *hmac(const char *name, const char *key, const char *input);

