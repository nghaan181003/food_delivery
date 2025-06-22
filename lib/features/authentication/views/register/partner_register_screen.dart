import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:food_delivery_h2d/common/widgets/images/image_picker.dart';
import 'package:food_delivery_h2d/common/widgets/keyboard/keyboard_hider.dart';
import 'package:food_delivery_h2d/features/authentication/controllers/partner_register_controller.dart';
import 'package:food_delivery_h2d/features/authentication/controllers/partner_tab_controller.dart';
import 'package:food_delivery_h2d/features/authentication/views/register/widgets/user_register_form.dart';
import 'package:food_delivery_h2d/features/customers/address_selection/controllers/address_selection_controller.dart';
import 'package:food_delivery_h2d/services/location_service.dart';
import 'package:food_delivery_h2d/utils/constants/colors.dart';
import 'package:food_delivery_h2d/utils/constants/sizes.dart';
import 'package:food_delivery_h2d/utils/helpers/helper_functions.dart';
import 'package:food_delivery_h2d/utils/helpers/location.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import '../../../../common/widgets/appbar/tabbar.dart';

class PartnerRegisterScreen extends StatelessWidget {
  PartnerRegisterScreen({super.key});

  final PartnerRegisterController _partnerRegisterController =
      Get.put(PartnerRegisterController());
  final AddressSelectionController _addressController =
      Get.put(AddressSelectionController());
  final PartnerTabController _tabController = Get.put(PartnerTabController());

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
              "Đăng ký đối tác",
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            bottom: MyTabbar(
                controller: _tabController.controller,
                tabs: _tabController.myTabs),
          ),
          body: Obx(
            () => (_partnerRegisterController.isLoading.value)
                ? const Center(child: CircularProgressIndicator())
                : TabBarView(controller: _tabController.controller, children: [
                    // Thông tin cơ bản
                    Padding(
                        padding: const EdgeInsets.all(MySizes.defaultSpace),
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              UserRegisterForm(
                                  emailController: _partnerRegisterController
                                      .emailController,
                                  nameController:
                                      _partnerRegisterController.nameController,
                                  phoneNumbController:
                                      _partnerRegisterController
                                          .phoneNumbController,
                                  passwordController: _partnerRegisterController
                                      .passwordController),
                              const SizedBox(
                                height: MySizes.spaceBtwInputFields,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Column(
                                    children: [
                                      Text(
                                        "CCCD (mặt trước)",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyLarge,
                                      ),
                                      const SizedBox(
                                        height: MySizes.spaceBtwInputFields,
                                      ),
                                      DottedBorderImagePicker(
                                        imageFile: _partnerRegisterController
                                            .CCCDFrontUrlImage.value,
                                        onTap: () => _partnerRegisterController
                                            .pickImage(
                                                _partnerRegisterController
                                                    .CCCDFrontUrlImage),
                                      ),
                                      const SizedBox(
                                        height: MySizes.spaceBtwItems,
                                      ),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      Text(
                                        "CCCD (mặt sau)",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyLarge,
                                      ),
                                      const SizedBox(
                                        height: MySizes.spaceBtwInputFields,
                                      ),
                                      DottedBorderImagePicker(
                                        imageFile: _partnerRegisterController
                                            .CCCDBackUrlImage.value,
                                        onTap: () => _partnerRegisterController
                                            .pickImage(
                                                _partnerRegisterController
                                                    .CCCDBackUrlImage),
                                      ),
                                      const SizedBox(
                                        height: MySizes.spaceBtwItems,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              ElevatedButton(
                                  onPressed: () {
                                    _tabController.next();
                                  },
                                  child: const Text("Tiếp tục"))
                            ],
                          ),
                        )),
                    // Thông tin hoạt động
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
                    // Ảnh và Danh mục món
                    SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(MySizes.defaultSpace),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Ảnh đại diện quán",
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                            const SizedBox(
                              height: MySizes.spaceBtwInputFields,
                            ),
                            DottedBorderImagePicker(
                              imageFile: _partnerRegisterController
                                  .avatarUrlImage.value,
                              onTap: () => _partnerRegisterController.pickImage(
                                  _partnerRegisterController.avatarUrlImage),
                            ),
                            const SizedBox(
                              height: MySizes.spaceBtwItems,
                            ),
                            Text(
                              "Ảnh mặt tiền",
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                            const SizedBox(
                              height: MySizes.spaceBtwInputFields,
                            ),
                            DottedBorderImagePicker(
                              imageFile: _partnerRegisterController
                                  .storeFrontUrlImage.value,
                              onTap: () => _partnerRegisterController.pickImage(
                                  _partnerRegisterController
                                      .storeFrontUrlImage),
                            ),
                            const SizedBox(
                              height: MySizes.spaceBtwItems,
                            ),
                            TextFormField(
                              controller: _partnerRegisterController
                                  .descriptionController,
                              decoration: const InputDecoration(
                                  hintText: "Nhập mô tả quán"),
                            ),
                            const SizedBox(
                              height: MySizes.spaceBtwSections,
                            ),
                            ElevatedButton(
                                onPressed: _partnerRegisterController.register,
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
