import 'package:flutter/material.dart';
import 'package:food_delivery_h2d/data/address/address_repository.dart';
import 'package:food_delivery_h2d/data/order/order_repository.dart';
import 'package:food_delivery_h2d/data/response/status.dart';
import 'package:food_delivery_h2d/utils/constants/colors.dart';
import 'package:food_delivery_h2d/utils/constants/sizes.dart';
import 'package:food_delivery_h2d/utils/popups/loaders.dart';
import 'package:get/get.dart';
import '../../../authentication/controllers/address_controller.dart';
import '../../../shippers/home/models/order_model.dart';

class OrderManagementController extends GetxController {
  static OrderManagementController get instance => Get.find();

  var isLoading = false.obs;
  var isLoadingDetail = false.obs;
  var orderList = <Order>[].obs;
  var order = Rxn<Order>();
  final _orderRepository = Get.put(OrderRepository());
  final addressController = Get.put(AddressController());
  final _addressRepository = Get.put(AddressRepository());
  var selectedStatus = ''.obs;

  int page = 1;
  var hasMore = true.obs;
  var errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchAllOrder();
  }

  Future<void> fetchAllOrder({bool loadMore = false}) async {
    if (isLoading.value) return;

    isLoading.value = true;

    if (loadMore) {
      page++;
    }

    try {
      final fetched = await _orderRepository.getAllOrderInAdmin(page: page);
      final newOrders = (fetched.data as List<Order>);

      orderList.assignAll(newOrders);

      hasMore.value = newOrders.isNotEmpty;
    } catch (e) {
      print("Error fetching orders: $e");
      isLoading.value = false;
    } finally {
      isLoading.value = false;
    }
  }

  void previousPage() {
    if (page > 1) {
      page--;
      fetchAllOrder();
    }
  }

  Future<void> fetchOrderById(String orderId) async {
    try {
      isLoadingDetail(true);

      final response = await _orderRepository.getOrderById(orderId);
      final fetchedOrder = response.data;

      if (fetchedOrder != null) {
        fetchedOrder.restAddress = await getFullAddress(
          fetchedOrder.restProvinceId,
          fetchedOrder.restDistrictId,
          fetchedOrder.restCommuneId,
          fetchedOrder.restDetailAddress,
        );
      }

      order.value = fetchedOrder;
    } catch (e) {
      print("Error fetching order: $e");
    } finally {
      isLoadingDetail(false);
    }
  }

  Future<String> getProvinceName(String provinceId) async {
    try {
      final provinces = await _addressRepository.getProvinces();
      return provinces.firstWhere((p) => p.id == provinceId).fullName;
    } catch (e) {
      print("Lỗi khi lấy tên tỉnh: $e");
      return "";
    }
  }

  Future<String> getDistrictName(String provinceId, String districtId) async {
    try {
      final districts = await _addressRepository.getDistrict(provinceId);
      return districts.firstWhere((d) => d.id == districtId).fullName;
    } catch (e) {
      print("Lỗi khi lấy tên quận/huyện: $e");
      return "";
    }
  }

  Future<String> getCommuneName(String districtId, String communeId) async {
    try {
      final communes = await _addressRepository.getCommunes(districtId);
      return communes.firstWhere((c) => c.id == communeId).fullName;
    } catch (e) {
      print("Lỗi khi lấy tên xã/phường: $e");
      return "";
    }
  }

  Future<String> getFullAddress(
    String? provinceId,
    String? districtId,
    String? communeId,
    String? detailAddress,
  ) async {
    if (provinceId == null || districtId == null || communeId == null) {
      return "Không xác định được địa chỉ";
    }

    try {
      final provinceName = await getProvinceName(provinceId);
      final districtName = await getDistrictName(provinceId, districtId);
      final communeName = await getCommuneName(districtId, communeId);

      return "$detailAddress, $communeName, $districtName, $provinceName";
    } catch (e) {
      print("Lỗi khi lấy địa chỉ đầy đủ: $e");
      return "Không xác định được địa chỉ";
    }
  }

  Future<void> fetchOrderByStatus(
      {bool loadMore = false, String? status}) async {
    if (isLoading.value) return;

    isLoading.value = true;

    if (loadMore) {
      page++;
    }

    try {
      final fetched = await _orderRepository.getOrderByStatus(
          page: page, status: status ?? selectedStatus.value);
      final newOrders = (fetched.data as List<Order>);

      orderList.assignAll(newOrders);

      hasMore.value = newOrders.isNotEmpty;
    } catch (e) {
      print("Error fetching orders: $e");
    } finally {
      isLoading.value = false;
    }
  }

  void updateStatus(String status) {
    selectedStatus.value = status;
    fetchOrderByStatus(status: status);
  }

  Future<void> searchOrderById({bool loadMore = false, String? id}) async {
    if (isLoading.value) return;

    isLoading.value = true;

    if (loadMore) {
      page++;
    }

    try {
      final fetched =
          await _orderRepository.searchOrderById(page: page, id: id);
      final newOrders = (fetched.data as List<Order>);
      orderList.assignAll(newOrders);

      hasMore.value = newOrders.isNotEmpty;
    } catch (e) {
      print("Error fetching orders: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteOrderById(String id) async {
    Get.defaultDialog(
      contentPadding: const EdgeInsets.all(MySizes.md),
      title: "Chắc chắn xóa",
      middleText: "Bạn chắc chắn xóa đơn hàng này",
      confirm: ElevatedButton(
        onPressed: () async {
          await _orderRepository.deleteOrderById(id);
          fetchAllOrder();
          Navigator.of(Get.overlayContext!).pop();

          Loaders.successSnackBar(
              title: "Thành công!", message: "Xóa thành công");
        },
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.all(0),
          backgroundColor: MyColors.darkPrimaryTextColor,
          side: const BorderSide(color: MyColors.darkPrimaryTextColor),
        ),
        child: const Text("Xóa"),
      ),
      cancel: OutlinedButton(
        style: OutlinedButton.styleFrom(
          padding:
              const EdgeInsets.symmetric(horizontal: MySizes.md, vertical: 0),
        ),
        onPressed: () => Navigator.of(Get.overlayContext!).pop(),
        child: const Text("Quay lại"),
      ),
    );
  }

  void approveOrderReport(String orderId) async {
    try {
      Map<String, dynamic> newStatus = {
        "custStatus": "cancelled",
        "driverStatus": "approved",
        "restStatus": "cancelled",
      };

      final res = await OrderRepository.instance
          .updateOrderStatus(orderId, null, newStatus, null);

      if (res.status == Status.ERROR) {
        Loaders.errorSnackBar(title: "Lỗi", message: res.message);
        return;
      }

      fetchAllOrder();
      Navigator.of(Get.overlayContext!).pop();

      Loaders.successSnackBar(
        title: "Thành công!",
        message: "Duyệt báo cáo đơn hàng thành công.",
      );
    } catch (e) {
      Loaders.errorSnackBar(title: "Thất bại!", message: e.toString());
      rethrow;
    }
  }

  void rejectOrderReport(String orderId) async {
    try {
      Map<String, dynamic> newStatus = {
        "custStatus": "cancelled",
        "driverStatus": "rejected",
        "restStatus": "cancelled",
      };

      final res = await OrderRepository.instance
          .updateOrderStatus(orderId, null, newStatus, null);

      if (res.status == Status.ERROR) {
        Loaders.errorSnackBar(title: "Lỗi", message: res.message);
        return;
      }

      fetchAllOrder();
      Navigator.of(Get.overlayContext!).pop();

      Loaders.successSnackBar(
        title: "Thành công!",
        message: "Từ chối báo cáo về đơn hàng thành công.",
      );
    } catch (e) {
      Loaders.errorSnackBar(title: "Thất bại!", message: e.toString());
      rethrow;
    }
  }
}
