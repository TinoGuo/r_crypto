import 'dart:ffi';
import 'dart:io';

const String _kMacOSTestDylib =
    'rust/target/x86_64-apple-darwin/release/librcrypto.dylib';
const String _kWindowsTestLib =
    'rust/target/x86_64-pc-windows-gnu/release/rcrypto.dll';
const String _kLinuxTestLib =
    'rust/target/x86_64-unknown-linux-gnu/release/librcrypto.so';

DynamicLibrary get testLib {
  final path = Directory.current;
  if (path.path.endsWith('example')) {
    return DynamicLibrary.open('../${_getByPlatformFileName()}');
  } else {
    return DynamicLibrary.open(_getByPlatformFileName());
  }
}

String _getByPlatformFileName() {
  if (Platform.isMacOS) {
    return _kMacOSTestDylib;
  } else if (Platform.isWindows) {
    return _kWindowsTestLib;
  } else if (Platform.isLinux) {
    return _kLinuxTestLib;
  } else {
    throw Exception("not support platform:${Platform.operatingSystem}");
  }
}
