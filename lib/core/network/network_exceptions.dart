/// Network and API exceptions
class NetworkException implements Exception {
  final String message;
  final int? statusCode;
  final dynamic originalException;

  NetworkException({
    required this.message,
    this.statusCode,
    this.originalException,
  });

  @override
  String toString() => 'NetworkException: $message (status: $statusCode)';
}

class TimeoutException extends NetworkException {
  TimeoutException({String message = 'Request timeout'})
    : super(message: message);
}

class UnauthorizedException extends NetworkException {
  UnauthorizedException({String message = 'Unauthorized'})
    : super(message: message, statusCode: 401);
}

class ForbiddenException extends NetworkException {
  ForbiddenException({String message = 'Forbidden'})
    : super(message: message, statusCode: 403);
}

class NotFoundException extends NetworkException {
  NotFoundException({String message = 'Not found'})
    : super(message: message, statusCode: 404);
}

class ServerException extends NetworkException {
  ServerException({String message = 'Server error'})
    : super(message: message, statusCode: 500);
}

class BadRequestException extends NetworkException {
  BadRequestException({String message = 'Bad request'})
    : super(message: message, statusCode: 400);
}
