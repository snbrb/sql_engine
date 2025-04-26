/// An exception thrown when an error occurs in the SQL engine operations.
class SqlEngineException implements Exception {
  /// A message describing the error.
  final String message;

  /// The original error that caused this exception (if any).
  final Object? cause;

  /// Creates a [SqlEngineException] with a given [message] and optional [cause].
  SqlEngineException(this.message, [this.cause]);

  @override
  String toString() =>
      'SqlEngineException: $message ${cause != null ? "Cause: $cause" : ""}';
}
