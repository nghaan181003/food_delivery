import 'package:food_delivery_h2d/data/response/status.dart';
import 'package:food_delivery_h2d/data/voucher/voucher_repository.dart';
import 'package:food_delivery_h2d/features/authentication/controllers/login_controller.dart';
import 'package:food_delivery_h2d/features/restaurants/voucher_management/enum/voucher_status.dart';
import 'package:food_delivery_h2d/features/restaurants/voucher_management/model/request/get_discount_request.dart';
import 'package:food_delivery_h2d/features/restaurants/voucher_management/model/voucher_model.dart';
import 'package:food_delivery_h2d/utils/popups/loaders.dart';
import 'package:get/get.dart';

class VoucherController extends GetxController {
  static VoucherController get instance => Get.find();

  final _voucherRepository = Get.put(VoucherRepository());

  var selectedVoucherStatus = VoucherStatus.all.obs();
  final vouchers = <VoucherModel>[].obs();
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    // Initialize any necessary data or services here
  }

  Future<void> getVouchers() async {
    try {
      isLoading.value = true;

      final partnerId = Get.find<LoginController>().currentUser.partnerId;
      final res = await _voucherRepository.getVoucherByShop(GetVoucherRequest(
          partnerId: partnerId, status: selectedVoucherStatus));

      if (res.status!.isERROR) {
        Loaders.errorSnackBar(title: "Thất bại!", message: res.message);
        return;
      }
      vouchers.assignAll(res.data ?? []);
    } catch (e) {
      Loaders.errorSnackBar(title: "Thất bại", message: e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> onCancel({required String id}) async {
    try {
      // FullScreenLoader.openDialog("Loading..", MyImagePaths.spoonAnimation);
      final res = await _voucherRepository.updateStatus(
          id: id, newStatus: VoucherStatus.canceled);
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
