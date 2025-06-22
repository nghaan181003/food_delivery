import 'package:food_delivery_h2d/bindings/network_manager.dart';
import 'package:food_delivery_h2d/data/partner/partner_repository.dart';
import 'package:food_delivery_h2d/features/admin/update_request/models/update_request.dart';
import 'package:food_delivery_h2d/features/authentication/controllers/login_controller.dart';
import 'package:get/get.dart';

class UpdateDriverRequestController extends GetxController{
  static UpdateDriverRequestController get instance => Get.find();
  var updateList = <UpdateRequest>[].obs;
  var isLoading = false.obs;
  var errorMessage = ''.obs;
  final _repository = PartnerRepository();

   @override
  void onInit() {
    fetchAllPartnerRequest();
    super.onInit();
  }

  Future<void> fetchAllPartnerRequest() async {
    try {
      isLoading(true);
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        return;
      }
      final data = await _repository.fetchAllDriverRequest(LoginController.instance.currentUser.userId);
      updateList.value = data;
    } catch (e) {
      errorMessage.value = e.toString();
      print(e);
    } finally {
      isLoading(false);
    }
  }
}