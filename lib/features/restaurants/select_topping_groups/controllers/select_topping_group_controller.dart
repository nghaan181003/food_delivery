import 'package:food_delivery_h2d/data/item/item_repository.dart';
import 'package:food_delivery_h2d/data/request/item/link_topping_request.dart';
import 'package:food_delivery_h2d/data/response/status.dart';
import 'package:food_delivery_h2d/features/restaurants/select_topping_groups/controllers/select_topping_group_state.dart';
import 'package:food_delivery_h2d/features/restaurants/topping_management/models/topping_group_model.dart';
import 'package:food_delivery_h2d/utils/popups/loaders.dart';
import 'package:get/get.dart';

class SelectToppingGroupController extends GetxController {
  final ItemRepository _itemRepository = Get.put(ItemRepository());
  static SelectToppingGroupController get instance => Get.find();

  var linkedToppingGroups = <ToppingGroupModel>[].obs;
  var unLinkedToppingGroups = <ToppingGroupModel>[].obs;
  var isLoading = false.obs;

  final String itemId;

  var resultStatus = Rxn<(bool success, String message)>();

  var state = SelectToppingGroupState().obs;

  SelectToppingGroupController({required this.itemId});

  @override
  void onInit() async {
    super.onInit();
    await onInitData();
  }

  Future<void> onInitData() async {
    try {
      isLoading.value = true;
      state.value =
          state.value.copyWith(status: SelectToppingGroupStatus.loading);
      final result = await Future.wait([
        _itemRepository.getLinkedToppingGroups(id: itemId),
        _itemRepository.getUnlinkedToppingGroups(id: itemId),
      ]);

      if (result[0].status == Status.ERROR ||
          result[1].status == Status.ERROR) {
        state.value = state.value.copyWith(
            status: SelectToppingGroupStatus.failed,
            message: result[0].message);
        return;
      }

      linkedToppingGroups.assignAll(result[0].data);
      unLinkedToppingGroups.assignAll(result[1].data);

      state.value =
          state.value.copyWith(status: SelectToppingGroupStatus.fetched);
    } catch (e) {
      state.value = state.value.copyWith(
          status: SelectToppingGroupStatus.failed, message: e.toString());
      return;
    }
  }

  void toggleToppingGroup(ToppingGroupModel toppingGroup) {
    if (linkedToppingGroups.contains(toppingGroup)) {
      // Nếu đang linked -> bỏ liên kết, chuyển qua unlinked
      linkedToppingGroups.remove(toppingGroup);
      unLinkedToppingGroups.add(toppingGroup);
    } else if (unLinkedToppingGroups.contains(toppingGroup)) {
      // Nếu đang unlinked -> liên kết, chuyển qua linked
      unLinkedToppingGroups.remove(toppingGroup);
      linkedToppingGroups.add(toppingGroup);
    }
  }

  Future<void> onSaveLinkToppingGroups() async {
    try {
      state.value =
          state.value.copyWith(status: SelectToppingGroupStatus.loading);
      final result = await _itemRepository.linkToppingGroup(
          linkToppingRequest: LinkToppingRequest(
        itemId: itemId,
        toppingGroupIds: linkedToppingGroups.map((e) => e.id ?? "").toList(),
      ));
      if (result.status == Status.ERROR) {
        state.value = state.value.copyWith(
            status: SelectToppingGroupStatus.failed, message: result.message);

        return;
      }

      state.value = state.value.copyWith(
          status: SelectToppingGroupStatus.linkToppingSuccess,
          message: result.message);
    } catch (e) {
      state.value = state.value.copyWith(
          status: SelectToppingGroupStatus.failed, message: e.toString());
      return;
    } finally {
      isLoading.value = false;
    }
  }
}
