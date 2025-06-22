import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:openai_api/src/app_core_factory.dart';
import 'package:openai_api/src/core/configurations/configurations.dart';


@module
abstract class DataSourceModule {
  @prod
  Dio dioProd() => AppCoreFactory.createDio(Configurations.baseUrl);
}
