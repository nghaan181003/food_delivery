import 'package:food_delivery_h2d/data/response/api_response.dart';
import 'package:food_delivery_h2d/data/response/pagination_response.dart';
import 'package:food_delivery_h2d/features/notification/models/notification_model.dart';
import 'package:food_delivery_h2d/utils/http/http_client.dart';
import 'package:get/get.dart';

class NotificationRepository extends GetxController {
  static NotificationRepository get instance => Get.find();

  Future<PaginationResponse<List<NotificationModel>>> getNotificationByUserId({
    required String userId,
    int page = 1,
    int limit = 10,
  }) async {
    try {
      final res = await HttpHelper.get("notification/$userId", queryParams: {
        'page': page,
        'limit': limit,
      });

      if (res["status"] == "error") {
        print("Error Message: ${res["message"]}");
        return PaginationResponse.error(res["message"]);
      }

      final list = (res['data'] as List)
          .map((item) => NotificationModel.fromJson(item))
          .toList();

      return PaginationResponse.completed(
        list,
        res["message"],
        totalPages: res["totalPages"],
        totalItems: res["totalItems"],
        currentPage: res["currentPage"],
        pageSize: res["pageSize"],
      );
    } catch (e) {
      return PaginationResponse.error(e.toString());
    }
  }

  Future<ApiResponse<NotificationModel>> createNotificationRaw(
      Map<String, dynamic> data) async {
    try {
      final res = await HttpHelper.post("notification", data);
      if (res["status"] == "error") {
        return ApiResponse.error(res["message"]);
      }
      return ApiResponse.completed(
        NotificationModel.fromJson(res["data"]),
        res["message"],
      );
    } catch (e) {
      return ApiResponse.error(e.toString());
    }
  }

  Future<ApiResponse<NotificationModel>> markAsRead(
      {required notificationId}) async {
    try {
      final res = await HttpHelper.patch("notification/read/$notificationId");
      if (res["status"] == "error") {
        return ApiResponse.error(res["message"]);
      }
      return ApiResponse.completed(
        NotificationModel.fromJson(res["data"]),
        res["message"],
      );
    } catch (e) {
      return ApiResponse.error(e.toString());
    }
  }

 Future<ApiResponse<NotificationModel>> deleteNotification({
  required notificationId,
}) async {
  try {
    final res = await HttpHelper.delete("notification/delete/$notificationId");

    if (res["status"] == "error") {
      return ApiResponse.error(res["message"]);
    }

    if (res["data"] == null) {
      return ApiResponse.completed(null, res["message"]);
    }

    return ApiResponse.completed(
      NotificationModel.fromJson(res["data"]),
      res["message"],
    );
  } catch (e) {
    return ApiResponse.error(e.toString());
  }
}

}
