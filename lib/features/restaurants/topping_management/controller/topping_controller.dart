import 'dart:math';

import 'package:flutter/material.dart';
import 'package:food_delivery_h2d/common/widgets/paginate/paginate.dart';
import 'package:food_delivery_h2d/data/response/status.dart';
import 'package:food_delivery_h2d/data/topping/topping_repository.dart';
import 'package:food_delivery_h2d/features/authentication/controllers/login_controller.dart';
import 'package:food_delivery_h2d/features/restaurants/topping_management/dummy/toppings.dart';
import 'package:food_delivery_h2d/features/restaurants/topping_management/models/topping_group_model.dart';
import 'package:food_delivery_h2d/features/restaurants/topping_management/models/topping_model.dart';
import 'package:food_delivery_h2d/utils/constants/animation_paths.dart';
import 'package:food_delivery_h2d/utils/constants/image_paths.dart';
import 'package:food_delivery_h2d/utils/popups/full_screen_loader.dart';
import 'package:food_delivery_h2d/utils/popups/loaders.dart';
import 'package:get/get.dart';

class ToppingController extends GetxController {
  final ToppingRepository _toppingRepository = Get.put(ToppingRepository());
  static ToppingController get instance => Get.find();

  var toppingGps = <Rx<ToppingGroupModel>>[].obs;

  var paginate = XPaginate<ToppingGroupModel>.initial().obs;

  final _limit = 7;
  var isLoading = false.obs;

  int? tempGroupIndex;

  @override
  void onInit() async {
    await getToppingsGpsV2();
    // getAllPages();
    super.onInit();
  }

  @override
  void onClose() {
    super.onClose();
  }

  Future<void> getToppingsGps() async {
    try {
      isLoading.value = true;
      toppingGps.clear();
      final partnerId = LoginController.instance.currentUser.partnerId;
      final res = await _toppingRepository.getAllByShop(
          partnerId: partnerId, limit: 100);

      if (res.status == Status.ERROR) {
        Loaders.errorSnackBar(title: "Thất bại!", message: res.message);
        return;
      }
      toppingGps.value = (res.data as List<ToppingGroupModel>)
          .map<Rx<ToppingGroupModel>>((e) => e.obs)
          .toList();
    } catch (err) {
      Loaders.errorSnackBar(title: "Thất bại!", message: err.toString());
    } finally {
      isLoading.value = false;
    }
  }

  // * Áp dụng phân trang
  Future<void> getToppingsGpsV2() async {
    final current = paginate.value;

    if (!current.canNext) return;
    paginate.value = current.loading();

    try {
      final partnerId = LoginController.instance.currentUser.partnerId;
      final res = await _toppingRepository.getAllByShop(
        partnerId: partnerId,
        page: current.currentPage + 1,
        limit: _limit,
      );
      if (res.status == Status.ERROR) {
        paginate.value = current.error(res.message);
        Loaders.errorSnackBar(title: "Lỗi", message: res.message ?? "");
        return;
      }

      paginate.value = paginate.value.appendV2(
        res,
        totalPages: res.totalPages,
        totalItems: res.totalItems,
        pageSize: res.pageSize,
      );

      toppingGps.value = (paginate.value.data ?? []).map((e) => e.obs).toList();
    } catch (e) {
      paginate.value = current.error(e.toString());
      Loaders.errorSnackBar(title: "Lỗi", message: e.toString());
    }
  }

  Future<void> saveTopping(ToppingModel newTopping) async {
    _onSaveTopping(newTopping);
    Get.back();
  }

  Future<void> saveToppingGroup(ToppingGroupModel newToppingGroup) async {
    try {
      FullScreenLoader.openDialog("Loading..", MyImagePaths.spoonAnimation);
      final partnerId = LoginController.instance.currentUser.partnerId;
      final res = await _toppingRepository
          .saveToppingGroup(newToppingGroup.copyWith(shopId: partnerId));

      if (res.status!.isERROR) {
        Loaders.errorSnackBar(title: "Thất bại!", message: res.message);
        return;
      }
      _onSaveToppingGroup(newToppingGroup.copyWith(
          id: res.data
              ?.id)); // ? Do api trả về không có danh sách toppings nên chấp vá
      Get.back();
      Loaders.successSnackBar(
        title: "Thành công!",
        message: newToppingGroup.isNew
            ? "Thêm Nhóm topping thành công"
            : "Cập nhật Nhóm topping thành công",
      );
    } catch (err) {
      Loaders.errorSnackBar(title: "Thất bại!", message: err.toString());
    } finally {
      FullScreenLoader.stopLoading();
    }
  }

  Future<void> onChangeIsActive(ToppingModel topping) async {
    try {
      if (topping.isNew) return;
      _onSaveTopping(topping.copyWith(isActive: !topping.isActive!));
    } catch (err) {
      Loaders.errorSnackBar(title: "Thất bại!", message: err.toString());
    }
  }

  Future<void> deleteTopping(ToppingModel topping) async {
    try {
      final res = await _toppingRepository.deleteTopping(topping.id ?? "");

      if (res.status!.isERROR) {
        Loaders.errorSnackBar(title: "Thất bại!", message: res.message);
        return;
      }

      if (_onRemoveTopping(res.data!)) {
        Get.back();
        Loaders.successSnackBar(
          title: "Thành công!",
          message: "Xóa Topping thành công",
        );
      }
    } catch (err) {
      Loaders.errorSnackBar(title: "Thất bại!", message: err.toString());
    }
  }

  Future<void> deleteToppingGroup(ToppingGroupModel toppingGroup) async {
    try {
      final res =
          await _toppingRepository.deleteToppingGroup(toppingGroup.id ?? "");

      if (res.status!.isERROR) {
        Loaders.errorSnackBar(title: "Thất bại!", message: res.message);
        return;
      }

      if (_onRemoveToppingGroup(res.data!)) {
        Get.back();
        Loaders.successSnackBar(
          title: "Thành công!",
          message: "Xóa Nhóm topping thành công",
        );
      }
    } catch (err) {
      Loaders.errorSnackBar(title: "Thất bại!", message: err.toString());
    }
  }

  bool _onSaveTopping(ToppingModel newTopping) {
    final idx =
        toppingGps.indexWhere((gp) => gp.value.id == newTopping.toppingGroupId);
    if (idx == -1) {
      return false;
    }

    final group = toppingGps[idx].value;
    List<ToppingModel> updatedToppings = [...group.toppings];

    final existingIdx = group.toppings.indexWhere((t) => t.id == newTopping.id);

    if (existingIdx != -1) {
      updatedToppings[existingIdx] = newTopping;
    } else {
      updatedToppings.add(newTopping);
    }

    toppingGps[idx].value = group.copyWith(toppings: updatedToppings);
    return true;
  }

  void _onSaveToppingGroup(ToppingGroupModel newToppingGroup) {
    final idx =
        toppingGps.indexWhere((gp) => gp.value.id == newToppingGroup.id);
    if (idx == -1) {
      toppingGps.add(newToppingGroup.obs);
    } else {
      toppingGps[idx].value = newToppingGroup;
    }
  }

  bool _onRemoveTopping(ToppingModel deleteTopping) {
    final gpIdx = toppingGps
        .indexWhere((gp) => gp.value.id == deleteTopping.toppingGroupId);
    if (gpIdx == -1) {
      return false;
    }

    final group = toppingGps[gpIdx].value;
    List<ToppingModel> updatedToppings = [...group.toppings];

    final tpIdx = group.toppings.indexWhere((t) => t.id == deleteTopping.id);
    if (tpIdx == -1) {
      return false;
    }

    updatedToppings.removeAt(tpIdx);
    toppingGps[gpIdx].value = group.copyWith(toppings: updatedToppings);
    return true;
  }

  bool _onRemoveToppingGroup(ToppingGroupModel deleteToppingGroup) {
    final gpIdx =
        toppingGps.indexWhere((gp) => gp.value.id == deleteToppingGroup.id);
    if (gpIdx == -1) {
      return false;
    }

    toppingGps.removeAt(gpIdx);
    return true;
  }

  ToppingGroupModel? findById(String tpGroupId) {
    return toppingGps
        .firstWhereOrNull((tpGroup) => tpGroup.value.id == tpGroupId)
        ?.value;
  }
}
