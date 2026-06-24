class RepositoryException implements Exception {
  RepositoryException(this.error, [this.stack]);

  String error;
  String? stack;

  @override
  String toString() {
    return error;
  }
}
