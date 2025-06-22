import 'package:dio/dio.dart';
import 'package:either_dart/either.dart';
import 'package:openai_api/src/utils/app_exception.dart';

import 'app_failure.dart';

abstract class DataState<T> {
  final T? data;
  // ignore: deprecated_member_use
  final DioError? dioError;

  const DataState({
    this.data,
    this.dioError,
  });
}

class DataSuccess<T> extends DataState<T> {
  DataSuccess({required super.data});
}

class DataFailed<T> extends DataState<T> {
  final AppFailure? appFailure;
  const DataFailed({required super.dioError, this.appFailure});
}

extension DataStateExtensions<T> on DataState<T> {
  Either<AppException, bool> toBoolResult() {
    if (this is DataFailed) {
      return Left(
        AppException(message: dioError?.message ?? 'Error'),
      );
    }
    return const Right(true);
  }
}
