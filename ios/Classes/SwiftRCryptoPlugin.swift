import Flutter
import UIKit

public class SwiftRCryptoPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    result(nil)
  }

  public func dummyMethodToEnforceBundling() {
      // dummy calls to prevent tree shaking
      blowfish_decrypt(0, "")
      blowfish_destroy(0)
      blowfish_encrypt(0, "")
      blowfish_new("")
      keccak224("")
      keccak256("")
      keccak384("")
      keccak512("")
      md5("")
      rust_cstr_free("");
      sha1("")
      sha224("")
      sha256("")
      sha384("")
      sha3_224("")
      sha3_256("")
      sha3_384("")
      sha3_512("")
      sha512("")
      sha512_trunc224("")
      sha512_trunc256("")
      shake_128("")
      shake_256("")
      hmac("", "", "")
  }
}
