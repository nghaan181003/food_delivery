import 'package:food_delivery_h2d/data/item/item_repository.dart';
import 'package:food_delivery_h2d/features/restaurants/menu_management/models/item_model.dart';
import 'package:food_delivery_h2d/utils/popups/loaders.dart';
import 'package:get/get.dart';

class ScheduleItemController extends GetxController {
  var isLoading = false.obs;
  final itemRepository = Get.put(ItemRepository());
  var item = Rxn<Item>();

  Future<void> updateSchedule( String id, List<DaySchedule> schedule) async {
    try {
      isLoading.value = true;

      await itemRepository.updateScheduleItem(id, schedule);

      Loaders.successSnackBar(
          title: "Thành công!",
          message: "Chỉnh sửa lịch bán món ăn thành công!");
    } catch (e) {
      Loaders.errorSnackBar(
          title: "Thất bại!",
          message: "Chỉnh sửa lịch lịch bán món ăn không thành công!");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchItemById(String id) async {
    try {
      isLoading.value = true;
      final res = await itemRepository.getItemById(id);
      item.value = res;
      print('Fetched item: $res');
    } catch (error) {
      print("Error fetching items: $error");
    } finally {
      isLoading.value = false;
    }
  }
}
