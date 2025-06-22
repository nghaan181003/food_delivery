import 'package:flutter/material.dart';
import 'package:food_delivery_h2d/features/admin/order_management/views/order_management_screen.dart';
import 'package:food_delivery_h2d/features/admin/update_request/views/driver_update_request_screen.dart';
import 'package:food_delivery_h2d/features/admin/update_request/views/partner_update_request_screen.dart';
import 'package:food_delivery_h2d/features/admin/approval_user/views/approval_user_list/approval_user_list.dart';
import 'package:food_delivery_h2d/features/admin/config/views/fee_config_view.dart';
import 'package:food_delivery_h2d/features/admin/dashboard/views/admin_dashboard.dart';
import 'package:food_delivery_h2d/features/admin/user_management/views/list_user/user_management.dart';
import 'package:food_delivery_h2d/features/authentication/views/login/login_screen.dart';
import 'package:food_delivery_h2d/routes/routes.dart';
import 'package:get/get.dart';

class AppRoutes {
  static final List<GetPage> pages = [
    GetPage(
        name: Routes.dashboard,
        page: () => const AdminDashboard(),
        transition: Transition.noTransition),
    GetPage(
        name: Routes.userManagement,
        page: () => const UserManagementScreen(),
        transition: Transition.noTransition),
    GetPage(
        name: Routes.approveRequest,
        page: () => const ApprovalUserList(),
        transition: Transition.noTransition),
    GetPage(
        name: Routes.logout,
        page: () => const LoginScreen(),
        transition: Transition.noTransition),
    GetPage(
        name: Routes.config,
        page: () => const ConfigView(),
        transition: Transition.noTransition),
    GetPage(
        name: Routes.approvePartnerRequest,
        page: () => PartnerUpdateRequestScreen(),
        transition: Transition.noTransition),
    GetPage(
        name: Routes.approveDriverRequest,
        page: () => DriverUpdateRequestScreen(),
        transition: Transition.noTransition),
    GetPage(
        name: Routes.orderManagement,
        page: () => const OrderManagementScreen(),
        transition: Transition.noTransition)
  ];
}
