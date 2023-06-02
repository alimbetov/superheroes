class ApiException implements Exception {
  String message;

  ApiException(this.message);

  @override
  String toString() {
    return 'ApiException{message: $message}';
  }
}
