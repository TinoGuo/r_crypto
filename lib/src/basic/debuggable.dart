import 'dart:ffi';
import 'dart:io';

const String _kMacOSTestDylib =
    'rust/target/x86_64-apple-darwin/release/librcrypto.dylib';
const String _kWindowsTestLib =
    'rust/target/x86_64-pc-windows-gnu/release/rcrypto.dll';

DynamicLibrary get testLib {
  final path = Directory.current;
  if (path.path.endsWith('test')) {
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
  } else {
    throw Exception("not support platform:${Platform.operatingSystem}");
  }
}
