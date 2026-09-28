class RepositoryException implements Exception {
  const RepositoryException(this.error, {this.cause, this.causeStack});

  /// Human-readable error message for UI display.
  final String error;

  /// Original exception object with its type preserved.
  final Object? cause;

  /// Original stack trace with its type preserved.
  final StackTrace? causeStack;

  @override
  String toString() => error;
}
