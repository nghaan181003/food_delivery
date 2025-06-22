import 'package:get_storage/get_storage.dart';
import 'package:food_delivery_h2d/routes/routes.dart';
import 'package:get/get.dart';

class SideBarController extends GetxController {
  final activeItem = Routes.dashboard.obs; 
  final hoverItem = ''.obs;
  final GetStorage _storage = GetStorage();

  @override
  void onInit() {
    super.onInit();
    activeItem.value = _storage.read('activeItem') ?? Routes.dashboard;
  }

  void changeActiveItem(String route) {
    activeItem.value = route;
    _storage.write('activeItem', route); 
  }

  void changeHoverItem(String route) {
    if (!isActive(route)) {
      hoverItem.value = route;
    }
  }

  bool isActive(String route) => activeItem.value == route;
  bool isHovering(String route) => hoverItem.value == route;

  void menuOnTap(String route) {
    if (route == Routes.logout) {
      logout(); 
    } else if (!isActive(route)) {
      changeActiveItem(route);
      Get.toNamed(route);
    }
  }

  void logout() {
    _storage.remove('activeItem');

    Get.offAllNamed(Routes.logout);
  }
}
