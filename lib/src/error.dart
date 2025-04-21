/// A custom exception class for handling errors related to FFI (Foreign Function Interface) operations.
class FfiException implements Exception {
  /// An error code.
  final String code;

  /// A human-readable error message, possibly null.
  final String? message;

  /// Error details, possibly null.
  final dynamic details;

  /// Native stacktrace for the error, possibly null.
  final String? stackTrace;

  /// Creates a new [FfiException] with the given parameters.
  FfiException({
    required this.code,
    this.message,
    this.details,
    this.stackTrace,
  });
}
