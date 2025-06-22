import 'package:food_delivery_h2d/data/discount/discount_repository.dart';
import 'package:food_delivery_h2d/data/discount/get_discount_request.dart';
import 'package:food_delivery_h2d/data/response/status.dart';
import 'package:food_delivery_h2d/features/authentication/controllers/login_controller.dart';
import 'package:food_delivery_h2d/features/restaurants/discount_management/enum/discount_status.dart';
import 'package:food_delivery_h2d/features/restaurants/discount_management/model/discount_model.dart';
import 'package:food_delivery_h2d/utils/constants/image_paths.dart';
import 'package:food_delivery_h2d/utils/popups/full_screen_loader.dart';
import 'package:food_delivery_h2d/utils/popups/loaders.dart';
import 'package:get/get.dart';

class DiscountManagementController extends GetxController {
  static DiscountManagementController get instance => Get.find();

  final _discountRepository = Get.put(DiscountRepository());

  var selectedDiscountStatus = DiscountStatus.all.obs();
  final discounts = <DiscountModel>[].obs();
  final isLoading = false.obs;

  Future<void> getDiscounts() async {
    try {
      isLoading.value = true;
      final partnerId = LoginController.instance.currentUser.partnerId;
      final res = await _discountRepository.getDiscounts(GetDiscountRequest(
          partnerId: partnerId, status: selectedDiscountStatus));

      if (res.status!.isERROR) {
        Loaders.errorSnackBar(title: "Thất bại!", message: res.message);
        return;
      }
      discounts.assignAll(res.data ?? []);
    } catch (e) {
      Loaders.errorSnackBar(title: "Thất bại", message: e);
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> onCancel({required String id}) async {
    try {
      // FullScreenLoader.openDialog("Loading..", MyImagePaths.spoonAnimation);
      final res = await _discountRepository.updateStatus(
          id: id, newStatus: DiscountStatus.canceled);
      if (res.status!.isERROR) {
        Loaders.errorSnackBar(title: "Thất bại!", message: res.message);
        return false;
      }
      return true;
    } catch (e) {
      Loaders.errorSnackBar(title: "Thất bại", message: e);
      return false;
    } finally {
      // FullScreenLoader.stopLoading();
    }
  }
}
