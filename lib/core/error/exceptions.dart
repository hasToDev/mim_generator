class ServerException implements Exception {
  ServerException({
    required this.message,
    required this.code,
  });

  final String message;
  final int code;
}
