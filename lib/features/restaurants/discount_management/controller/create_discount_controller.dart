import 'package:food_delivery_h2d/data/discount/discount_repository.dart';
import 'package:food_delivery_h2d/data/response/status.dart';
import 'package:food_delivery_h2d/features/authentication/controllers/login_controller.dart';
import 'package:food_delivery_h2d/features/restaurants/discount_management/model/discount_model.dart';
import 'package:food_delivery_h2d/utils/constants/image_paths.dart';
import 'package:food_delivery_h2d/utils/popups/full_screen_loader.dart';
import 'package:food_delivery_h2d/utils/popups/loaders.dart';
import 'package:get/get.dart';

class CreateDiscountController extends GetxController {
  final DiscountRepository _discountRepository = Get.put(DiscountRepository());
  static CreateDiscountController get instance => Get.find();

  Future<bool> createDiscount(DiscountModel newDiscount) async {
    try {
      print("START DATE ${newDiscount.startDate.toIso8601String()}");
      print("END DATE ${newDiscount.endDate.toIso8601String()}");
      FullScreenLoader.openDialog("Loading..", MyImagePaths.spoonAnimation);
      final partnerId = LoginController.instance.currentUser.partnerId;
      final res = await _discountRepository
          .createDiscount(newDiscount.copyWith(shopId: partnerId));

      if (res.status!.isERROR) {
        Loaders.errorSnackBar(title: "Thất bại!", message: res.message);
        return false;
      }

      Loaders.successSnackBar(
        title: "Thành công!",
        message: res.message,
      );
      return true;
    } catch (err) {
      Loaders.errorSnackBar(title: "Thất bại!", message: err.toString());
      return false;
    } finally {
      FullScreenLoader.stopLoading();
    }
  }
}
