// import 'package:food_delivery_h2d/data/item/item_repository.dart';
// import 'package:food_delivery_h2d/data/response/status.dart';
// import 'package:food_delivery_h2d/data/voucher/voucher_repository.dart';
// import 'package:food_delivery_h2d/features/authentication/controllers/login_controller.dart';
// import 'package:food_delivery_h2d/features/restaurants/menu_management/models/item_model.dart';
// import 'package:food_delivery_h2d/features/restaurants/voucher_management/model/request/get_voucher_order_request.dart';
// import 'package:food_delivery_h2d/features/restaurants/voucher_management/model/voucher_model.dart';
// import 'package:food_delivery_h2d/utils/constants/image_paths.dart';
// import 'package:food_delivery_h2d/utils/popups/full_screen_loader.dart';
// import 'package:food_delivery_h2d/utils/popups/loaders.dart';
// import 'package:get/get.dart';

// class SelectVoucherController extends GetxController {
//   static SelectVoucherController get instance => Get.find();

//   final _voucherRepository = Get.put(VoucherRepository());

//   final List<VoucherModel> vouchers = <VoucherModel>[];
//   var isLoading = false.obs;

//   Future<void> getVouchersInOrder() async {
//     try {
//       isLoading.value = true;
//       final partnerId = LoginController.instance.currentUser.partnerId;
//       final res =
//           await _voucherRepository.getVoucherInOrder(GetVoucherOrderRequest(shopId: shopId, productIds: productIds, totalOrderAmount: totalOrderAmount, userId: userId));

//       if (res.status!.isERROR) {
//         Loaders.errorSnackBar(title: "Thất bại!", message: res.message);
//         return;
//       }

//       items.assignAll(res.data ?? []);
//     } catch (e) {
//       Loaders.errorSnackBar(title: "Thất bại", message: e);
//     } finally {
//       isLoading.value = false;
//     }
//   }
// }
