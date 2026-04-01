sealed class AppException implements Exception {
  final String message;

  const AppException(this.message);

  @override
  String toString() => message;
}

/// Network error: HTTP request fails
final class NetworkException extends AppException {
  const NetworkException() : super('No internet connection. Please check your network and try again.');
}

/// API responds with non-200 status code
final class ServerException extends AppException {
  const ServerException(int statusCode) : super('Unexpected response from the server (status $statusCode).');
}

/// API response cannot be parsed into an accessible structure
final class ParseException extends AppException {
  const ParseException() : super('Failed to read data from the server.');
}
