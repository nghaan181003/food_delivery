import 'package:food_delivery_h2d/data/notification/notification_repository.dart';
import 'package:food_delivery_h2d/data/response/status.dart';
import 'package:food_delivery_h2d/features/authentication/controllers/login_controller.dart';
import 'package:food_delivery_h2d/features/notification/models/notification_model.dart';
import 'package:food_delivery_h2d/utils/popups/loaders.dart';
import 'package:get/get.dart';

class NotificationController extends GetxController {
  static NotificationController get instance => Get.find();

  final notifications = <NotificationModel>[].obs;
  final isLoading = false.obs;
  final isLoadingMore = false.obs;
  final errorMessage = ''.obs;

  var currentPage = 1;
  var totalPages = 1;
  final int pageSize = 6;
  final NotificationRepository _repository = NotificationRepository();

  int get countNotificationNotRead =>
      notifications.where((n) => n.isRead.value == false).length;
  @override
  void onInit() {
    super.onInit();
    fetchNotifications();
  }

  Future<void> fetchNotifications({int page = 1}) async {
    if (page == 1) {
      isLoading.value = true;
    } else {
      isLoadingMore.value = true;
    }

    errorMessage.value = '';
    print("User ID: ${LoginController.instance.currentUser.userId}");
    try {
      final res = await _repository.getNotificationByUserId(
        userId: LoginController.instance.currentUser.userId,
        page: page,
        limit: pageSize,
      );

      if (res.status == Status.OK) {
        if (page == 1) {
          notifications.assignAll(res.data!);
        } else {
          notifications.addAll(res.data!);
        }

        currentPage = res.currentPage ?? 1;
        totalPages = res.totalPages ?? 1;
      } else {
        errorMessage.value = res.message ?? 'Lỗi không xác định';
      }
    } catch (e) {
      errorMessage.value = e.toString();
      isLoading.value = false;
      print(e);
    } finally {
      isLoading.value = false;
      isLoadingMore.value = false;
    }
  }

  void loadMore() {
    if (!isLoadingMore.value && currentPage < totalPages) {
      fetchNotifications(page: currentPage + 1);
    }
  }

  Future<void> sendAcceptedNotification(String recipientId) async {
    final data = {
      "title": "Đơn hàng đã được xác nhận",
      "content":
          "Đơn hàng của bạn đã được nhận và đang được chuẩn bị. Cảm ơn bạn đã đặt hàng!",
      "recipientId": recipientId,
    };

    try {
      final res = await _repository.createNotificationRaw(data);

      if (res.status == Status.OK) {
        print("gửi thông báo thành công");
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> sendDeliveriedNotification(String recipientId) async {
    final data = {
      "title": "Đơn hàng đã giao thành công",
      "content":
          "Đơn hàng của bạn đã được giao thành công. Chúc bạn ngon miệng và hẹn gặp lại!",
      "recipientId": recipientId,
    };

    try {
      final res = await _repository.createNotificationRaw(data);

      if (res.status == Status.OK) {
        print("gửi thông báo thành công");
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> sendCancelNotification(String recipientId) async {
    final data = {
      "title": "Đơn hàng bị hủy",
      "content":
          "Rất tiếc! Đơn hàng của bạn đã bị hủy. Nếu có nhu cầu, bạn vui lòng đặt lại đơn hàng khác!",
      "recipientId": recipientId,
    };

    try {
      final res = await _repository.createNotificationRaw(data);

      if (res.status == Status.OK) {
        print("gửi thông báo thành công");
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> markAsRead(String notificationId) async {
    try {
      final res = await _repository.markAsRead(notificationId: notificationId);

      if (res.status == Status.OK) {
        print("Đã đọc");
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> deleteNotification(String notificationId) async {
    try {
      final res =
          await _repository.deleteNotification(notificationId: notificationId);

      if (res.status == Status.OK) {
        await fetchNotifications();
        Loaders.successSnackBar(
          title: "Thành công!",
          message: res.message ?? "Xóa thông báo thành công",
        );
      } else {
        Loaders.errorSnackBar(
          title: "Thất bại!",
          message: res.message ?? "Không thể xóa thông báo",
        );
      }
    } catch (e) {
      errorMessage.value = "Error delete notification: ${e.toString()}";
    }
  }

  Future<void> sendApproveUpdateNotification(String recipientId) async {
    final data = {
      "title": "Yêu cầu chỉnh sửa đã được duyệt",
      "content":
          "Chúc mừng! Yêu cầu chỉnh sửa thông tin của bạn đã được duyệt. Thông tin mới sẽ sớm được cập nhật.",
      "recipientId": recipientId,
    };

    try {
      final res = await _repository.createNotificationRaw(data);

      if (res.status == Status.OK) {
        print("gửi thông báo thành công");
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> sendRejectUpdateNotification(String recipientId) async {
    final data = {
      "title": "Yêu cầu chỉnh sửa bị từ chối",
      "content":
          "Rất tiếc! Yêu cầu chỉnh sửa thông tin của bạn đã bị từ chối. Vui lòng kiểm tra lại thông tin và gửi lại nếu cần.",
      "recipientId": recipientId,
    };

    try {
      final res = await _repository.createNotificationRaw(data);

      if (res.status == Status.OK) {
        print("gửi thông báo thành công");
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> sendNotificationToVoucher(String recipientId, String idOrder) async {
    final data = {
      "title": "Bạn vừa được voucher mới",
      "content":
          "Quý khách vừa nhận được voucher giảm giá từ đơn hàng #$idOrder.",
      "recipientId": recipientId,
    };

    try {
      final res = await _repository.createNotificationRaw(data);

      if (res.status == Status.OK) {
        print("gửi thông báo thành công");
      }
    } catch (e) {
      print(e);
    }
  }
}
