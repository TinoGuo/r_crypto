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
        let fake: UnsafeMutablePointer<UInt8>? = nil
        let len: UInt32 = 0
        hash_data(0, fake, len, fake, len, fake, len, fake, len, fake, len)
        hash_file(0, fake, len, fake, len, fake, len, "", fake, len)
    }
}
