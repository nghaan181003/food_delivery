import 'package:food_delivery_h2d/data/partner/partner_repository.dart';
import 'package:food_delivery_h2d/utils/popups/loaders.dart';
import 'package:get/get.dart';
import 'package:food_delivery_h2d/features/customers/restaurant_list/models/detail_partner_model.dart';
import 'package:food_delivery_h2d/features/authentication/controllers/login_controller.dart';

class ScheduleController extends GetxController {
  var isLoading = false.obs;
  final partnerRepository = Get.put(PartnerRepository());

  Future<void> updateSchedule(List<DaySchedule> schedule) async {
    try {
      isLoading.value = true;

      final partnerId = LoginController.instance.currentUser.partnerId;

      await partnerRepository.updateSchedulePartner(partnerId, schedule);

      Loaders.successSnackBar(
          title: "Thành công!",
          message: "Chỉnh sửa lịch đóng/mở cửa thành công!");
    } catch (e) {
      Loaders.errorSnackBar(
          title: "Thất bại!",
          message: "Chỉnh sửa lịch đóng/mở cửa không thành công!");
    } finally {
      isLoading.value = false;
    }
  }
}
