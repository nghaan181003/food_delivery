enum AppFailure {
  systemFailure(0),
  unAuthorized(401),
  serverFailure(500),
  notDataFound(404);

  const AppFailure(this.code);

  final int code;

  static AppFailure fromCode(int code) {
    switch (code) {
      case 401:
        return AppFailure.unAuthorized;
      case 500:
        return AppFailure.serverFailure;
      case 404:
        return AppFailure.notDataFound;
      default:
        return AppFailure.systemFailure;
    }
  }
}
