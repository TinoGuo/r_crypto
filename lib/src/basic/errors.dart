/// Wrap Rust error
class RustError extends Error {
  final String message;

  RustError._(this.message);

  /// Read error message from [error]
  factory RustError(int error) {
    var message;
    switch (error) {
      case -1:
        message = "The path is invalid";
        break;
      case -2:
        message = "Open the target file failed";
        break;
      case -3:
        message = "Read the target file failed";
        break;
      case -4:
        message = "Not exist hash type";
        break;
      case -5:
        message = "Create Hash instance failed";
        break;
      default:
        message = "Unknown";
        break;
    }
    return RustError._(message);
  }
}
