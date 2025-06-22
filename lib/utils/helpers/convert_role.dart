import 'package:flutter/material.dart';
import 'package:food_delivery_h2d/features/authentication/views/register/customer_register_screen.dart';
import 'package:food_delivery_h2d/features/authentication/views/register/driver_register_screen.dart';
import 'package:food_delivery_h2d/features/authentication/views/register/partner_register_screen.dart';
import 'package:food_delivery_h2d/utils/constants/colors.dart';
import 'package:food_delivery_h2d/utils/constants/enums.dart';
import 'package:food_delivery_h2d/utils/constants/image_paths.dart';
import 'package:food_delivery_h2d/utils/popups/loaders.dart';
import 'package:get/get.dart';

class ConvertEnumRole {
  static String toDisplayName(UserRole role) {
    switch (role) {
      case UserRole.admin:
        return "Quản trị viên";
      case UserRole.partner:
        return "Đối tác";
      case UserRole.driver:
        return "Tài xế";
      case UserRole.customer:
        return "Khách hàng";
      default:
        return "Unknown";
    }
  }

  static String toImagePath(UserRole role) {
    switch (role) {
      case UserRole.admin:
        return MyImagePaths.adminIcon;
      case UserRole.partner:
        return MyImagePaths.partnerIcon;
      case UserRole.driver:
        return MyImagePaths.driverIcon;
      case UserRole.customer:
        return MyImagePaths.customerIcon;
      default:
        return "Unknown";
    }
  }

  static void toPage(UserRole role) {
    switch (role) {
      case UserRole.admin:
        Loaders.warningSnackBar(title: "Không được đăng ký admin!");
      case UserRole.partner:
        Get.to(() => PartnerRegisterScreen());
      case UserRole.driver:
        Get.to(() => DriverRegisterScreen());
      // TODO: Handle this case.
      case UserRole.customer:
        Get.to(() => CustomerRegisterScreen());
    }
  }

  static UserRole toEnum(String displayName) {
    switch (displayName) {
      case "Quản trị viên":
        return UserRole.admin;
      case "Đối tác":
        return UserRole.partner;
      case "Tài xế":
        return UserRole.driver;
      case "Khách hàng":
        return UserRole.customer;
      default:
        throw Exception('Invalid role');
    }
  }

  static Color getStatusColor(bool status) {
    return status ? MyColors.successColor : MyColors.primaryColor;
  }

  static Color getColorByRole(String role) {
    switch (role) {
      case 'admin':
        return Colors.purple;
      case 'driver':
        return Colors.green;
      case 'partner':
        return Colors.orange;
      case 'customer':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  static String roleToDisplayName(String role) {
    switch (role) {
      case "admin":
        return "Quản trị viên";
      case "partner":
        return "Đối tác";
      case "driver":
        return "Tài xế";
      case "customer":
        return "Khách hàng";
      default:
        return "Không xác định";
    }
  }

  static UserRole convertToEnum(String displayName) {
    switch (displayName) {
      case "admin":
        return UserRole.admin;
      case "partner":
        return UserRole.partner;
      case "driver":
        return UserRole.driver;
      case "customer":
        return UserRole.customer;
      default:
        throw Exception('Invalid role');
    }
  }
}
