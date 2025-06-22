import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:openai_api/src/data/models/thread/create_thread_response.dart';
import 'package:openai_api/src/data/models/thread/thread_messages_response.dart';
import 'package:retrofit/retrofit.dart';

part 'gpt_api.g.dart';

@RestApi()
@injectable
abstract class GPTApi {
  static const String chatApi = "/chat/completions";
  static const String threadApi = "/threads";

  @factoryMethod
  factory GPTApi(Dio dio) = _GPTApi;

  @POST(chatApi)
  Future<HttpResponse> chat({@Body() required Map<String, dynamic> body});

  @GET("$threadApi/{id}/messages")
  Future<HttpResponse<ThreadMessagesResponse?>> threadMessages(
      @Path() String id, @Queries() Map<String, dynamic> queries);

  @POST("$threadApi/{id}/messages")
  Future<HttpResponse> sendThreadMessage(
      @Path() String id, @Body() Map<String, dynamic> body);

  @POST("$threadApi/{id}/runs")
  Future<HttpResponse> threadRuns(
      @Path() String id, @Body() Map<String, dynamic> body);

  @POST(threadApi)
  Future<HttpResponse<CreateThreadResponse?>> createThread(
      @Body() Map<String, dynamic> body);

  @DELETE("$threadApi/{id}")
  Future<HttpResponse> deleteThread(@Path() String id);
}
