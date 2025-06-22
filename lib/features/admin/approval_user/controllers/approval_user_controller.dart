import 'package:food_delivery_h2d/bindings/network_manager.dart';
import 'package:food_delivery_h2d/data/user/user_repository.dart';
import 'package:food_delivery_h2d/features/admin/dashboard/controllers/user_management_controller.dart';
import 'package:food_delivery_h2d/features/admin/user_management/models/driver_model.dart';
import 'package:food_delivery_h2d/features/admin/user_management/models/partner_model.dart';
import 'package:food_delivery_h2d/features/admin/user_management/models/user_model.dart';
import 'package:food_delivery_h2d/utils/popups/loaders.dart';
import 'package:get/get.dart';

class ApprovalUserController extends GetxController {
  var userList = <UserModel>[].obs;
  var isLoading = true.obs;
  var errorMessage = ''.obs;
  var errorMessageDriver = ''.obs;
  var errorMessagePartner = ''.obs;
  var selectedRole = ''.obs;
  var detailDriver = Rxn<DriverModel>();
  var detailPartner = Rxn<PartnerModel>();
  final UserRepository _repository = UserRepository();
  var isDriverLoading = false.obs;
  var isPartnerLoading = false.obs;
  final UserManagementController controller =
      Get.put(UserManagementController());

  @override
  void onInit() {
    super.onInit();
    fetchUserByRole();
  }

  Future<void> fetchUserByRole({String? role}) async {
    try {
      isLoading(true);
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        errorMessage.value = "No internet connection";
        return;
      }

      final data =
          await _repository.fetchUserByRole(role: role ?? selectedRole.value);
          print(data);
      userList.value = data;
    } catch (e) {
      errorMessage.value = e.toString();
      print(e);
    } finally {
      isLoading(false);
    }
  }

  Future<void> fetchDetailDriver(String driverId) async {
    try {
      isDriverLoading(true);
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        errorMessageDriver.value = "No internet connection";
        return;
      }

      final driverResponse = await _repository.fetchDriverById(driverId);
      detailDriver.value = driverResponse;
    } catch (e) {
      errorMessageDriver.value =
          "Error fetching driver details: ${e.toString()}";
    } finally {
      isDriverLoading(false);
    }
  }

  Future<void> fetchDetailPartner(String partnerId) async {
    try {
      isPartnerLoading(true);
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        errorMessagePartner.value = "No internet connection";
        return;
      }

      final partnerResponse = await _repository.fetchPartnerById(partnerId);
      detailPartner.value = partnerResponse;
      print(
          "Controller received partnerResponse: ${partnerResponse.toString()}");
    } catch (e) {
      errorMessagePartner.value =
          "Error fetching partner details: ${e.toString()}";
    } finally {
      isPartnerLoading(false);
    }
  }

  Future<void> approveUser(String userId) async {
    try {
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        errorMessage.value = "No internet connection";
        return;
      }

      final isApproved = await _repository.approveUser(userId);
      if (isApproved) {
        fetchUserByRole();
        controller.fetchAllUsers();

        Loaders.successSnackBar(
            title: "Thành công!", message: "Duyệt người dùng thành công");
      } else {
        errorMessage.value = "Failed to approve user";
      }
    } catch (e) {
      errorMessage.value = "Error approving user: ${e.toString()}";
    }
  }

  void updateRole(String role) {
    selectedRole.value = role;
    fetchUserByRole(role: role);
  }

  Future<void> deleteApprove(String userId) async {
    try {
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        errorMessage.value = "No internet connection";
        return;
      }
      await _repository.deleteApprove(userId);
      fetchUserByRole();

      Loaders.successSnackBar(title: "Thành công!", message: "Từ chối thành công");
    } catch (e) {
      errorMessage.value = "Error delete user: ${e.toString()}";
    }
  }
}
