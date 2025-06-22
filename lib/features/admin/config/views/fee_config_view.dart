import 'package:flutter/material.dart';
import 'package:food_delivery_h2d/features/admin/config/controller/config_controller.dart';
import 'package:food_delivery_h2d/features/admin/web_layout.dart';
import 'package:food_delivery_h2d/utils/constants/colors.dart';
import 'package:get/get.dart';

class ConfigView extends StatelessWidget {
  const ConfigView({super.key});

  @override
  Widget build(BuildContext context) {
    final ConfigController controller = Get.put(ConfigController());

    return WebLayout(
      body: Scaffold(
        appBar: AppBar(
          title: const Text('Quản lý phí vận chuyển'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Obx(() => controller.isLoading.value
              ? const Center(child: CircularProgressIndicator())
              : Card(
                  elevation: 4,
                  child: SizedBox(
                    width: 400,
                    child: Padding(
                      padding: const EdgeInsets.only(
                          right: 32.0, left: 32, top: 32, bottom: 32),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Text(
                              'Cấu hình phí vận chuyển',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: MyColors.primaryTextColor,
                                  ),
                            ),
                          ),
                          const SizedBox(height: 32),
                          TextFormField(
                            controller: controller.baseFeeController,
                            decoration: const InputDecoration(
                              labelText: 'Phí cơ bản (VNĐ)',
                              border: OutlineInputBorder(),
                            ),
                            keyboardType: TextInputType.number,
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: controller.additionalFeeController,
                            decoration: const InputDecoration(
                              labelText: 'Phí thêm mỗi km (VNĐ)',
                              border: OutlineInputBorder(),
                            ),
                            keyboardType: TextInputType.number,
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: controller.surchargeController,
                            decoration: const InputDecoration(
                              labelText: 'Phụ phí (VNĐ)',
                              border: OutlineInputBorder(),
                            ),
                            keyboardType: TextInputType.number,
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: controller.descriptionController,
                            decoration: const InputDecoration(
                              labelText: 'Mô tả',
                              border: OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(height: 32),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              if (controller.hasDeliveryFeeConfig.value)
                                OutlinedButton(
                                  onPressed: () => controller.removeConfig(
                                      controller.editingConfigId.value),
                                  child: const Text("Xóa"),
                                ),
                              const SizedBox(width: 8),
                              ElevatedButton(
                                onPressed: controller.isLoading.value
                                    ? null
                                    : () => controller.saveConfig(),
                                child: Text(
                                    controller.hasDeliveryFeeConfig.value
                                        ? 'Cập nhật'
                                        : 'Tạo cấu hình'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                )),
        ),
      ),
    );
  }
}
