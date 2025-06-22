
import 'package:food_delivery_h2d/features/authentication/models/User.dart';
import 'package:food_delivery_h2d/utils/http/http_client.dart';
import 'package:get/get.dart';

class CustomerRepository extends GetxController {
  static CustomerRepository get instance => Get.find();

  Future<UserModel> getCurrentUser(String userId) async {
    try {
      final res = await HttpHelper.get("user/$userId");
      print("repository $res");
      return UserModel.fromJson(res["data"]);
    } on Exception catch (e) {
      print("Error approving user: $e");
      rethrow;
    }
  }
}
