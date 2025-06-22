import 'package:either_dart/either.dart';

class AppException implements Exception {
  final String message;
  final int? code;
  final int? s;
  AppException({required this.message, this.code, this.s});
}

typedef SResult<T> = Either<AppException, T>;