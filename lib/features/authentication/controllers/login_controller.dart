import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery_h2d/bindings/network_manager.dart';
import 'package:food_delivery_h2d/data/authentication/auth_repository.dart';
import 'package:food_delivery_h2d/data/customer/customer_repository.dart';
import 'package:food_delivery_h2d/data/driver/driver_repository.dart';
import 'package:food_delivery_h2d/data/partner/partner_repository.dart';
import 'package:food_delivery_h2d/data/response/status.dart';
import 'package:food_delivery_h2d/features/authentication/models/User.dart';
import 'package:food_delivery_h2d/features/authentication/views/login/login_screen.dart';
import 'package:food_delivery_h2d/features/customers/customer_navigation_menu.dart';
import 'package:food_delivery_h2d/features/restaurants/home/restaurant_home_screen.dart';
import 'package:food_delivery_h2d/features/shippers/common/controllers/driver_location_controller.dart';
import 'package:food_delivery_h2d/features/shippers/shipper_navigation_menu.dart';
import 'package:food_delivery_h2d/routes/routes.dart';
import 'package:food_delivery_h2d/services/location_service.dart';
import 'package:food_delivery_h2d/utils/constants/enums.dart';
import 'package:food_delivery_h2d/utils/popups/loaders.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class LoginController extends GetxController {
  static LoginController get instance => Get.find();

  var isShowPassword = false.obs;
  var isLoading = false.obs;

  // TextEdit Controllers
  final _localStorage = GetStorage();
  final userNameController = TextEditingController();
  final passwordController = TextEditingController();
  final selectedRole = UserRole.customer.obs;

  GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();

  // Repository
  final AuthRepository _authRepository = Get.put(AuthRepository());
  final DriverRepository _driverRepository = Get.put(DriverRepository());
  final PartnerRepository _partnerRepository = Get.put(PartnerRepository());
  final CustomerRepository _userRepository = Get.put(CustomerRepository());
  final DriverLocationController _driverLocationController =
      Get.put(DriverLocationController());

  void saveUser(dynamic user) {
    _localStorage.write("currentUser", user);
  }

  void saveLocation(Position position) {
    final locationData = {
      'latitude': position.latitude,
      'longitude': position.longitude,
      'timestamp': position.timestamp.toIso8601String(),
    };
    _localStorage.write('currentLocation', locationData);
  }

  dynamic get currentUser {
    return _localStorage.read<UserModel>("currentUser");
  }

  dynamic get currentLocation {
    return _localStorage.read<Map<String, dynamic>>("currentLocation");
  }

  Future<Position?> getCurrentLocation() async {
    try {
      return LocationService.getLocation();
    } catch (e) {
      return null;
    }
  }

  void togglePasswordVisibility() {
    isShowPassword.value = !isShowPassword.value;
  }

  void login() async {
    var role = selectedRole.value.name;

    if (kIsWeb) {
      role = UserRole.admin.name;
    }

    try {
      isLoading.value = true;

      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        Loaders.errorSnackBar(
            title: "No Connection!", message: "Check your internet.");
        return;
      }

      if (!loginFormKey.currentState!.validate()) {
        return;
      }

      final res = await _authRepository.testLogin(
          userNameController.text.trim(), passwordController.text.trim(), role);

      if (res.status == Status.ERROR) {
        Loaders.errorSnackBar(title: "Thất bại!", message: res.message);
        return;
      }

      final userRole = res.data!.user.role;
      final userId = res.data!.user.userId;

      if (userRole == "driver") {
        final currentDriver = await _driverRepository.getCurrentDriver(userId);
        saveUser(currentDriver);
        var currentLocation = await getCurrentLocation();
        if (currentLocation != null) {
          saveLocation(currentLocation);
          await _driverRepository.updateDriverLocation(userId, currentLocation);
        }
        _driverLocationController.initializeLocationTracking(currentDriver);
        Loaders.successSnackBar(title: "Thành công!", message: res.message);
        Get.offAll(() => const ShipperNavigationMenu());
      } else if (userRole == "partner") {
        final currentPartner =
            await _partnerRepository.getCurrentPartner(userId);
        saveUser(currentPartner);
        Loaders.successSnackBar(title: "Thành công!", message: res.message);
        Get.offAll(() => const RestaurantHomeScreen());
      } else if (userRole == "customer") {
        final currentCustomer = await _userRepository.getCurrentUser(userId);
        saveUser(currentCustomer);
        var currentLocation = await getCurrentLocation();
        if (currentLocation != null) {
          saveLocation(currentLocation);
        }
        Loaders.successSnackBar(title: "Thành công!", message: res.message);
        Get.offAll(() => const CustomerNavigationMenu());
      } else {
        Loaders.successSnackBar(title: "Thành công!", message: res.message);
        if (kIsWeb) {
          Get.toNamed(Routes.dashboard);
        } else {
          Loaders.customToast(message: 'Chỉ đăng nhập bằng website!');
        }
      }
    } catch (err) {
      Loaders.errorSnackBar(title: "Thất bại!", message: err.toString());
      print(err);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    _localStorage.remove("currentUser");
    final user = currentUser;
    if (user?.role == 'driver') {
      debugPrint('[LoginController] Logging out driver: ${user.userId}');
      await _driverLocationController.updateLocationOnLogout(user.userId);
    }

    Get.offAll(() => const LoginScreen());
  }

  Future<void> refreshCurrentUser() async {
    final user = currentUser;
    final userId = user?.userId;
    final role = user?.role;

    if (userId != null && role != null) {
      dynamic updatedUser;

      if (role == "customer") {
        updatedUser = await _userRepository.getCurrentUser(userId);
      } else if (role == "driver") {
        updatedUser = await _driverRepository.getCurrentDriver(userId);
      } else if (role == "partner") {
        updatedUser = await _partnerRepository.getCurrentPartner(userId);
      }

      if (updatedUser != null) {
        saveUser(updatedUser); // ghi đè lại currentUser
      }
    }
  }
}
