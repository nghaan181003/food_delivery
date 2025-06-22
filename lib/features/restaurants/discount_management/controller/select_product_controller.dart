import 'package:food_delivery_h2d/data/item/item_repository.dart';
import 'package:food_delivery_h2d/data/response/status.dart';
import 'package:food_delivery_h2d/features/authentication/controllers/login_controller.dart';
import 'package:food_delivery_h2d/features/restaurants/menu_management/models/item_model.dart';
import 'package:food_delivery_h2d/utils/constants/image_paths.dart';
import 'package:food_delivery_h2d/utils/popups/full_screen_loader.dart';
import 'package:food_delivery_h2d/utils/popups/loaders.dart';
import 'package:get/get.dart';

class SelectProductController extends GetxController {
  static SelectProductController get instance => Get.find();

  final _itemRepository = Get.put(ItemRepository());

  final List<Item> items = <Item>[];
  var isLoading = false.obs;

  Future<void> getProducts() async {
    try {
      isLoading.value = true;
      final partnerId = LoginController.instance.currentUser.partnerId;
      final res =
          await _itemRepository.getItemsByPartnerId(partnerId: partnerId);

      if (res.status!.isERROR) {
        Loaders.errorSnackBar(title: "Thất bại!", message: res.message);
        return;
      }

      items.assignAll(res.data ?? []);
    } catch (e) {
      Loaders.errorSnackBar(title: "Thất bại", message: e);
    } finally {
      isLoading.value = false;
    }
  }
}
