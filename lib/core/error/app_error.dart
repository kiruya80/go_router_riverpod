class AppError implements Exception {
  final String message;

  AppError(this.message);

  @override
  String toString() => 'AppError: $message';
}

class NetworkError extends AppError {
  NetworkError(super.message);
}

class UnauthorizedError extends AppError {
  UnauthorizedError(super.message);
}
