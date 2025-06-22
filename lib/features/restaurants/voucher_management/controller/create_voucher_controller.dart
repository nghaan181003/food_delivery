import 'dart:math';

import 'package:food_delivery_h2d/data/response/status.dart';
import 'package:food_delivery_h2d/data/voucher/voucher_repository.dart';
import 'package:food_delivery_h2d/features/authentication/controllers/login_controller.dart';
import 'package:food_delivery_h2d/features/restaurants/voucher_management/model/voucher_model.dart';
import 'package:food_delivery_h2d/utils/constants/image_paths.dart';
import 'package:food_delivery_h2d/utils/popups/full_screen_loader.dart';
import 'package:food_delivery_h2d/utils/popups/loaders.dart';
import 'package:get/get.dart';

class CreateVoucherController extends GetxController {
  final VoucherRepository _voucherRepository = Get.put(VoucherRepository());
  static CreateVoucherController get instance => Get.find();

  Future<bool> createVoucher(VoucherModel newVoucher) async {
    try {
      FullScreenLoader.openDialog("Loading..", MyImagePaths.spoonAnimation);
      final partnerId = LoginController.instance.currentUser.partnerId;
      final res = await _voucherRepository.createVoucher(
          newVoucher.copyWith(shopId: partnerId).toCreateVoucherModel);

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
