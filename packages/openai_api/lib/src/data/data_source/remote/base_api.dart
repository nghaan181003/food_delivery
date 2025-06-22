// ignore_for_file: deprecated_member_use

import 'dart:io';
import 'package:dio/dio.dart';
import 'package:openai_api/src/utils/data_state.dart';
import 'package:retrofit/dio.dart';
import '../../../utils/app_failure.dart';

abstract class BaseApi {
  final String dataNullError = "Data null";
  final String baseError = "Error";

  Future<DataState<T>> getStateOf<T>({
    required Future<HttpResponse<T>> Function() request,
  }) async {
    try {
      final httpResponse = await request();

      if (httpResponse.response.statusCode == HttpStatus.ok) {
        return DataSuccess(data: httpResponse.data);
      } else {
        return DataFailed(
          dioError: DioError(
            requestOptions: httpResponse.response.requestOptions,
            response: httpResponse.response,
          ),
        );
      }
    } on DioError catch (error) {
      return DataFailed(
          dioError: error,
          appFailure: AppFailure.fromCode(error.response?.statusCode ?? 0));
    }
  }
}
