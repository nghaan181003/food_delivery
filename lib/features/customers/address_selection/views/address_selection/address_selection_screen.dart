import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:food_delivery_h2d/common/widgets/appbar/custom_app_bar.dart';
import 'package:food_delivery_h2d/features/customers/address_selection/controllers/address_selection_controller.dart';
import 'package:food_delivery_h2d/utils/constants/sizes.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';

class AddressSelectionScreen extends StatelessWidget {
  AddressSelectionScreen({super.key, required this.isUpdate, this.orderId});
  final bool isUpdate;
  final String? orderId;

  @override
  Widget build(BuildContext context) {
    Get.create<AddressSelectionController>(() => AddressSelectionController());
    final AddressSelectionController addressController =
        Get.find<AddressSelectionController>();
    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          // Xóa controller khi rời khỏi màn hình
          Get.delete<AddressSelectionController>();
        }
      },
      child: Scaffold(
        appBar: const CustomAppBar(
          title: Text("Địa chỉ"),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(MySizes.defaultSpace),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const SizedBox(height: MySizes.spaceBtwInputFields),

                TextFormField(
                  initialValue: "Thành phố Hồ Chí Minh",
                  decoration:
                      const InputDecoration(labelText: "Tỉnh/Thành phố"),
                  enabled: false,
                ),
                const SizedBox(height: MySizes.spaceBtwInputFields),

                // Dropdown Quận/Huyện
                Obx(
                  () => DropdownButtonFormField(
                    decoration: const InputDecoration(labelText: "Quận/Huyện"),
                    value: addressController.selectedDistrictId.value.isNotEmpty
                        ? addressController.selectedDistrictId.value
                        : null,
                    items: addressController.districts.map((district) {
                      return DropdownMenuItem<String>(
                        value: district.id,
                        child: Text(district.fullName),
                      );
                    }).toList(),
                    onChanged: (value) {
                      addressController
                          .updateSelectedDistrictId(value.toString());
                    },
                  ),
                ),
                const SizedBox(height: MySizes.spaceBtwInputFields),

                // Dropdown Phường/Xã
                Obx(
                  () => DropdownButtonFormField(
                    decoration: const InputDecoration(labelText: "Phường/Xã"),
                    value: addressController.selectedCommuneId.value.isNotEmpty
                        ? addressController.selectedCommuneId.value
                        : null,
                    items: addressController.communes.map((commune) {
                      return DropdownMenuItem<String>(
                        value: commune.id,
                        child: Text(commune.fullName),
                      );
                    }).toList(),
                    onChanged: (value) {
                      addressController
                          .updateSelectedCommuneId(value.toString());
                    },
                  ),
                ),
                const SizedBox(height: MySizes.spaceBtwInputFields),

                // Ô nhập địa chỉ chi tiết
                Obx(
                  () => TextFormField(
                    controller: addressController.detailAddressController,
                    decoration: InputDecoration(
                      labelText: "Địa chỉ chi tiết",
                      suffix: Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Text(
                            "${addressController.lengthDetailAddress}/255"),
                      ),
                    ),
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(255),
                    ],
                    onChanged: (value) {
                      addressController.handleDetailAddressChange(value);
                    },
                    readOnly: true,
                    onTap: () {
                      addressController.showMapPopup(context);
                    },
                  ),
                ),
                const SizedBox(height: MySizes.spaceBtwInputFields),

                Align(
                  alignment: Alignment.centerLeft,
                  child: Wrap(
                    spacing: 16.0,
                    children: [
                      TextButton.icon(
                        onPressed: () =>
                            addressController.showMapPopup(context),
                        icon: const Icon(Icons.map),
                        label: const Text("Chọn từ bản đồ"),
                      ),
                      TextButton.icon(
                        onPressed: addressController.fetchCurrentLocation,
                        icon: const Icon(Icons.my_location),
                        label: const Text("Sử dụng vị trí hiện tại"),
                      ),
                    ],
                  ),
                ),

                // Nút Xác nhận
                ElevatedButton(
                  onPressed: () async {
                    await addressController.confirmAddress(
                      isUpdate: isUpdate,
                      orderId: orderId,
                    );
                  },
                  child: const Text("Xác nhận"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
