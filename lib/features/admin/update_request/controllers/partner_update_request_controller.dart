import 'package:food_delivery_h2d/bindings/network_manager.dart';
import 'package:food_delivery_h2d/data/response/status.dart';
import 'package:food_delivery_h2d/data/update_profile/update_profile_repository.dart';
import 'package:food_delivery_h2d/features/admin/update_request/models/update_request.dart';
import 'package:food_delivery_h2d/utils/popups/loaders.dart';
import 'package:get/get.dart';

class PartnerUpdateRequestController extends GetxController {
  static PartnerUpdateRequestController get instance => Get.find();
  var updateList = <UpdateRequest>[].obs;
  var isLoading = true.obs;
  var errorMessage = ''.obs;
  final _repository = UpdateProfileRepository();

  @override
  void onInit() {
    fetchAllRequest();
    super.onInit();
  }

  void fetchAllRequest() async {
    try {
      isLoading(true);
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        return;
      }
      final data = await _repository.fetchAllPartnerRequest();
      updateList.value = data;
    } catch (e) {
      errorMessage.value = e.toString();
      print(e);
    } finally {
      isLoading(false);
    }
  }

  Future<void> approveUpdate(String id) async {
    try {
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        errorMessage.value = "No internet connection";
        return;
      }

      final isApproved = await _repository.approvePartnerUpdate(id);
      if (isApproved) {
        fetchAllRequest();

        Loaders.successSnackBar(
            title: "Thành công!", message: "Duyệt yêu cầu thành công");
      } else {
        errorMessage.value = "Duyệt yêu cầu thất bại";
      }
    } catch (e) {
      errorMessage.value = "Duyệt yêu cầu thất bại: ${e.toString()}";
    }
  }

  Future<void> rejectUpdateRequest(String id) async {
    try {
      final res = await _repository.rejectPartnerUpdateRequest(id);

      if (res.status == Status.OK) {
        fetchAllRequest();
        Loaders.successSnackBar(
          title: "Thành công!",
          message: res.message ?? "Từ chối yêu cầu thành công",
        );
      } else {
        Loaders.errorSnackBar(
          title: "Thất bại!",
          message: res.message ?? "Không thể từ chối yêu cầu",
        );
      }
    } catch (e) {
      errorMessage.value = "Error reject request: ${e.toString()}";
    }
  }
}
