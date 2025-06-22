import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:food_delivery_h2d/common/widgets/images/image_picker.dart';
import 'package:food_delivery_h2d/common/widgets/keyboard/keyboard_hider.dart';
import 'package:food_delivery_h2d/features/authentication/controllers/driver_register_controller.dart';
import 'package:food_delivery_h2d/features/authentication/controllers/driver_tab_controller.dart';
import 'package:food_delivery_h2d/features/authentication/views/register/widgets/user_register_form.dart';
import 'package:food_delivery_h2d/features/customers/address_selection/controllers/address_selection_controller.dart';
import 'package:food_delivery_h2d/utils/constants/colors.dart';
import 'package:food_delivery_h2d/utils/constants/sizes.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';

import '../../../../common/widgets/appbar/tabbar.dart';

class DriverRegisterScreen extends StatelessWidget {
  DriverRegisterScreen({super.key});

  final DriverRegisterController _driverRegisterController =
      Get.put(DriverRegisterController());
  final AddressSelectionController _addressController =
      Get.put(AddressSelectionController());
  final DriverTabController _tabController = Get.put(DriverTabController());

  void _showMapPopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final size = MediaQuery.of(context).size;
        final dialogWidth = size.width;
        final dialogHeight = size.height * 0.8;
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: Container(
            height: dialogHeight,
            width: dialogWidth,
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Chọn vị trí trên bản đồ",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                // Bản đồ trong popup
                Expanded(
                  child: FutureBuilder<LatLng>(
                    future: _addressController.getInitialPositionForMap(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      final initialCenter =
                          snapshot.data ?? const LatLng(10.7769, 106.7009);
                      return Obx(
                        () => FlutterMap(
                          options: MapOptions(
                            initialCenter: initialCenter,
                            initialZoom: 15.0,
                            onTap: (tapPosition, point) {
                              // Cập nhật tọa độ và đóng popup
                              _addressController.updateLocationFromMap(
                                point.latitude,
                                point.longitude,
                              );
                              Navigator.pop(context);
                            },
                          ),
                          children: [
                            TileLayer(
                              urlTemplate:
                                  'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                              userAgentPackageName:
                                  'com.example.food_delivery_h2d',
                            ),
                            MarkerLayer(
                              markers: [
                                if (_addressController.latitude.value != 0.0 &&
                                    _addressController.longitude.value != 0.0)
                                  Marker(
                                    point: LatLng(
                                      _addressController.latitude.value,
                                      _addressController.longitude.value,
                                    ),
                                    child: const Icon(
                                      Icons.location_pin,
                                      color: Colors.red,
                                      size: 40,
                                    ),
                                  ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: KeyboardHider(
        child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
                onPressed: () => Get.back(),
                icon: const Icon(
                  Icons.arrow_back_ios,
                  color: MyColors.primaryTextColor,
                  size: MySizes.iconMd,
                )),
            title: Text(
              "Đăng ký tài xế",
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            bottom: MyTabbar(
                controller: _tabController.controller,
                tabs: _tabController.myTabs),
          ),
          body: Obx(
            () => (_driverRegisterController.isLoading.value)
                ? const Center(child: CircularProgressIndicator())
                : TabBarView(controller: _tabController.controller, children: [
                    // Thông tin cơ bản
                    SingleChildScrollView(
                      child: Padding(
                          padding: const EdgeInsets.all(MySizes.defaultSpace),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              UserRegisterForm(
                                  emailController:
                                      _driverRegisterController.emailController,
                                  nameController:
                                      _driverRegisterController.nameController,
                                  phoneNumbController: _driverRegisterController
                                      .phoneNumbController,
                                  passwordController: _driverRegisterController
                                      .passwordController),
                              const SizedBox(
                                height: MySizes.spaceBtwInputFields,
                              ),
                              ElevatedButton(
                                  onPressed: () {
                                    _tabController.next();
                                  },
                                  child: const Text("Tiếp tục"))
                            ],
                          )),
                    ),
                    // Thông tin cư trú
                    SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(MySizes.defaultSpace),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            TextFormField(
                              initialValue: "Thành phố Hồ Chí Minh",
                              decoration: const InputDecoration(
                                  labelText: "Tỉnh/Thành phố"),
                              enabled: false,
                            ),
                            const SizedBox(
                              height: MySizes.spaceBtwInputFields,
                            ),
                            Obx(
                              () => DropdownButtonFormField(
                                  decoration: const InputDecoration(
                                      labelText: "Quận/Huyện"),
                                  value: _addressController
                                          .selectedDistrictId.value.isNotEmpty
                                      ? _addressController
                                          .selectedDistrictId.value
                                      : null,
                                  items: _addressController.districts
                                      .map((district) {
                                    return DropdownMenuItem<String>(
                                        value: district.id,
                                        child: Text(district.fullName));
                                  }).toList(),
                                  onChanged: (value) {
                                    _addressController.updateSelectedDistrictId(
                                        value.toString());
                                  }),
                            ),
                            const SizedBox(
                              height: MySizes.spaceBtwInputFields,
                            ),
                            Obx(
                              () => DropdownButtonFormField(
                                  decoration: const InputDecoration(
                                      labelText: "Phường/Xã"),
                                  value: _addressController
                                          .selectedCommuneId.value.isNotEmpty
                                      ? _addressController
                                          .selectedCommuneId.value
                                      : null,
                                  items: _addressController.communes
                                      .map((commune) {
                                    return DropdownMenuItem<String>(
                                        value: commune.id,
                                        child: Text(commune.fullName));
                                  }).toList(),
                                  onChanged: (value) {
                                    _addressController.updateSelectedCommuneId(
                                        value.toString());
                                  }),
                            ),
                            const SizedBox(
                              height: MySizes.spaceBtwInputFields,
                            ),
                            Obx(
                              () => TextFormField(
                                controller:
                                    _addressController.detailAddressController,
                                decoration: InputDecoration(
                                  labelText: "Địa chỉ chi tiết",
                                  suffix: Padding(
                                    padding: const EdgeInsets.only(left: 8.0),
                                    child: Text(
                                        "${_addressController.lengthDetailAddress}/255"),
                                  ),
                                ),
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(255),
                                ],
                                onChanged: (value) {
                                  _addressController
                                      .handleDetailAddressChange(value);
                                },
                                onTap: () {
                                  _showMapPopup(context);
                                },
                              ),
                            ),
                            const SizedBox(
                              height: MySizes.spaceBtwInputFields,
                            ),
                            TextButton.icon(
                              onPressed: () => _showMapPopup(context),
                              icon: const Icon(Icons.map),
                              label: const Text("Chọn từ bản đồ"),
                            ),
                            ElevatedButton(
                                onPressed: () {
                                  _tabController.next();
                                },
                                child: const Text("Tiếp tục"))
                          ],
                        ),
                      ),
                    ),
                    // Bằng lái & Phương tiện
                    SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(MySizes.defaultSpace),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Giấy phép lái xe (mặt trước)",
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                            const SizedBox(
                              height: MySizes.spaceBtwInputFields,
                            ),
                            DottedBorderImagePicker(
                              imageFile: _driverRegisterController
                                  .licenseFrontPlateImage.value,
                              onTap: () => _driverRegisterController.pickImage(
                                  _driverRegisterController
                                      .licenseFrontPlateImage),
                            ),
                            const SizedBox(
                              height: MySizes.spaceBtwItems,
                            ),
                            Text(
                              "Giấy phép lái xe (mặt sau)",
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                            const SizedBox(
                              height: MySizes.spaceBtwInputFields,
                            ),
                            DottedBorderImagePicker(
                              imageFile: _driverRegisterController
                                  .licenseBackPlateImage.value,
                              onTap: () => _driverRegisterController.pickImage(
                                  _driverRegisterController
                                      .licenseBackPlateImage),
                            ),
                            const SizedBox(
                              height: MySizes.spaceBtwItems,
                            ),
                            TextFormField(
                              controller: _driverRegisterController
                                  .licensePlateController,
                              decoration: const InputDecoration(
                                  hintText: "Nhập biển số xe"),
                            ),
                            const SizedBox(
                              height: MySizes.spaceBtwSections,
                            ),
                            ElevatedButton(
                                onPressed: _driverRegisterController.register,
                                child: const Text("Đăng ký"))
                          ],
                        ),
                      ),
                    )
                  ]),
          ),
        ),
      ),
    );
  }
}
