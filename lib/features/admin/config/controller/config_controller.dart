import 'package:flutter/material.dart';
import 'package:food_delivery_h2d/data/config/config_repository.dart';
import 'package:food_delivery_h2d/data/response/status.dart';
import 'package:food_delivery_h2d/features/admin/config/models/fee_config_model.dart';
import 'package:food_delivery_h2d/utils/popups/loaders.dart';
import 'package:get/get.dart';

class ConfigController extends GetxController {
  final ConfigRepository configRepo = Get.put(ConfigRepository());

  // Trạng thái
  var config = Rxn<Config>();
  var isLoading = false.obs;
  var errorMessage = ''.obs;
  var hasDeliveryFeeConfig = false.obs;

  // Form input
  var editingConfigId = ''.obs;
  var baseFee = ''.obs;
  var additionalFee = ''.obs;
  var surcharge = ''.obs;
  var description = ''.obs;

  final baseFeeController = TextEditingController();
  final additionalFeeController = TextEditingController();
  final surchargeController = TextEditingController();
  final descriptionController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    fetchDeliveryConfig();
    baseFeeController.addListener(() => baseFee.value = baseFeeController.text);
    additionalFeeController
        .addListener(() => additionalFee.value = additionalFeeController.text);
    surchargeController
        .addListener(() => surcharge.value = surchargeController.text);
    descriptionController
        .addListener(() => description.value = descriptionController.text);
  }

  @override
  void onClose() {
    baseFeeController.dispose();
    additionalFeeController.dispose();
    surchargeController.dispose();
    descriptionController.dispose();
    super.onClose();
  }

  Future<void> fetchDeliveryConfig() async {
    isLoading.value = true;
    errorMessage.value = '';
    final response = await configRepo.getDeliveryFeeConfig();
    isLoading.value = false;

    if (response.status == Status.OK && response.data != null) {
      config.value = response.data;
      hasDeliveryFeeConfig.value = true;
      editConfig(config.value!);
    } else {
      config.value = null;
      hasDeliveryFeeConfig.value = false;
      resetForm();
      errorMessage.value =
          response.message ?? 'Không tìm thấy cấu hình phí vận chuyển';
      Loaders.errorSnackBar(title: 'Lỗi', message: errorMessage.value);
    }
  }

  void editConfig(Config config) {
    editingConfigId.value = config.id ?? '';
    baseFeeController.text = config.data['baseFee']?.toString() ?? '';
    additionalFeeController.text =
        config.data['additionalFeePerKm']?.toString() ?? '';
    surchargeController.text = config.data['surcharge']?.toString() ?? '';
    descriptionController.text = config.description ?? '';
  }

  Future<void> saveConfig() async {
    if (isLoading.value) {
      return;
    }

    if (baseFee.value.isEmpty ||
        additionalFee.value.isEmpty ||
        surcharge.value.isEmpty) {
      errorMessage.value = 'Vui lòng nhập đầy đủ các trường';
      Loaders.errorSnackBar(title: 'Lỗi', message: errorMessage.value);
      return;
    }

    final baseFeeValue = double.tryParse(baseFee.value);
    final additionalFeeValue = double.tryParse(additionalFee.value);
    final surchargeValue = double.tryParse(surcharge.value);

    if (baseFeeValue == null || baseFeeValue <= 0) {
      errorMessage.value = 'Phí cơ bản phải là số dương';
      Loaders.errorSnackBar(title: 'Lỗi', message: errorMessage.value);
      return;
    }
    if (additionalFeeValue == null || additionalFeeValue <= 0) {
      errorMessage.value = 'Phí thêm mỗi km phải là số dương';
      Loaders.errorSnackBar(title: 'Lỗi', message: errorMessage.value);
      return;
    }
    if (surchargeValue == null || surchargeValue < 0) {
      errorMessage.value = 'Phụ phí phải là số không âm';
      Loaders.errorSnackBar(title: 'Lỗi', message: errorMessage.value);
      return;
    }

    final config = Config(
      id: editingConfigId.value.isEmpty ? null : editingConfigId.value,
      type: 'DELIVERY_FEE',
      data: {
        'baseFee': baseFeeValue,
        'additionalFeePerKm': additionalFeeValue,
        'surcharge': surchargeValue,
      },
      description: description.value.isEmpty ? null : description.value,
    );

    isLoading.value = true;
    errorMessage.value = '';

    final response = hasDeliveryFeeConfig.value
        ? await configRepo.updateConfig(config)
        : await configRepo.addConfig(config);

    isLoading.value = false;

    if (response.status == Status.OK) {
      await fetchDeliveryConfig();
      Loaders.successSnackBar(
          title: 'Thành công',
          message: response.message ?? 'Lưu cấu hình thành công!');
    } else {
      errorMessage.value = response.message ?? 'Lỗi khi lưu cấu hình';
      Loaders.errorSnackBar(title: 'Lỗi', message: errorMessage.value);
    }
  }

  Future<void> removeConfig(String configId) async {
    if (isLoading.value) {
      return;
    }

    Get.defaultDialog(
      title: 'Xác nhận',
      middleText: 'Bạn có chắc muốn xóa cấu hình này?',
      textConfirm: 'Xóa',
      textCancel: 'Hủy',
      onConfirm: () async {
        Get.back();
        isLoading.value = true;
        errorMessage.value = '';
        final response = await configRepo.removeConfig(configId);
        isLoading.value = false;

        if (response.status == Status.OK) {
          await fetchDeliveryConfig();
          Loaders.successSnackBar(
              title: 'Thành công',
              message: response.message ?? 'Xóa cấu hình thành công!');
        } else {
          errorMessage.value = response.message ?? 'Lỗi khi xóa cấu hình';
          Loaders.errorSnackBar(title: 'Lỗi', message: errorMessage.value);
        }
      },
    );
  }

  void resetForm() {
    editingConfigId.value = '';
    baseFeeController.clear();
    additionalFeeController.clear();
    surchargeController.clear();
    descriptionController.clear();
  }
}
