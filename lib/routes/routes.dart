class Routes {
  static const dashboard = "/dashboard";
  static const userManagement = "/user-management";
  static const approveRequest = "/approve-request";
  static const approvePartnerRequest = "/approve-partner-request";
  static const approveDriverRequest = "/approve-driver-request";
  static const orderManagement = "/order-management";
  static const config = "/config";
  static const logout = "/";
  static List sideBarItems = [
    dashboard,
    userManagement,
    approveRequest,
    approveDriverRequest,
    approvePartnerRequest,
    orderManagement,
    config,
    logout
  ];
}
