import 'package:food_delivery_h2d/data/response/pagination_response.dart';
import 'package:food_delivery_h2d/data/response/status.dart';
import 'package:food_delivery_h2d/features/customers/order/controllers/order_controller.dart';
import 'package:food_delivery_h2d/features/restaurants/topping_management/models/topping_group_model.dart';

enum PageStatus { initial, loading, error, success }

class XPaginate<T> {
  final String? message;
  final List<T>? data;

  PageStatus status;
  int currentPage;
  int totalPages;
  int totalItems;
  int pageSize;

  bool get hasMore => currentPage < totalPages;
  bool get canNext => hasMore && !isLoading;

  T? get lastDoc => (data?.isNotEmpty == true) ? data!.last : null;

  XPaginate({
    this.message,
    this.data,
    this.status = PageStatus.initial,
    this.currentPage = 0,
    this.totalPages = 9999,
    this.totalItems = 0,
    this.pageSize = 10,
  });

  factory XPaginate.initial() => XPaginate<T>();

  bool get isInitial => status == PageStatus.initial;
  bool get isLoading => status == PageStatus.loading;
  bool get isCompleted => status == PageStatus.success;
  bool get isError => status == PageStatus.error;

  XPaginate<T> loading() {
    if (canNext && status != PageStatus.initial) {
      return XPaginate(
        data: data,
        currentPage: currentPage,
        totalPages: totalPages,
        totalItems: totalItems,
        pageSize: pageSize,
        status: PageStatus.loading,
      );
    } else {
      return XPaginate();
    }
  }

  XPaginate<T> copyWith({
    String? message,
    List<T>? data,
    PageStatus? status,
    int? currentPage,
    int? totalPages,
    int? totalItems,
    int? pageSize,
  }) {
    return XPaginate(
      message: message ?? this.message,
      data: data ?? this.data,
      status: status ?? this.status,
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages ?? this.totalPages,
      totalItems: totalItems ?? this.totalItems,
      pageSize: pageSize ?? this.pageSize,
    );
  }

  XPaginate<T> append(
    List<T> newData, {
    int? currentPage,
    int? totalPages,
    int? totalItems,
    int? pageSize,
    String? message,
  }) {
    final List<T> currentData = data ?? <T>[];
    final List<T> updated = List<T>.from(currentData)..addAll(newData);
    return XPaginate<T>(
      data: updated,
      message: message,
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages ?? this.totalPages,
      totalItems: totalItems ?? this.totalItems,
      pageSize: pageSize ?? this.pageSize,
      status: PageStatus.success,
    );
  }

  XPaginate<T> appendV2(
    PaginationResponse<List<T>> newData, {
    int? totalPages,
    int? totalItems,
    int? pageSize,
    String? message,
  }) {
    status = newData.status!.isOK ? PageStatus.success : PageStatus.error;
    final List<T> items = [
      ...data ?? [],
      ...newData.data ?? [],
    ];
    if (items.isNotEmpty && canNext == false) {
      print("End list");
    }
    if (canNext) {
      currentPage++;
    }

    return XPaginate<T>(
      currentPage: currentPage,
      data: items,
      message: message,
      totalPages: totalPages ?? this.totalPages,
      totalItems: totalItems ?? this.totalItems,
      pageSize: pageSize ?? this.pageSize,
      status: PageStatus.success,
    );
  }

  XPaginate<T> error(String? message) {
    return copyWith(status: PageStatus.error, message: message);
  }

  @override
  String toString() {
    return "XPaginate{"
        "status: $status, "
        "message: $message, "
        "currentPage: $currentPage, "
        "totalPages: $totalPages, "
        "totalItems: $totalItems, "
        "pageSize: $pageSize, "
        "data: ${data?.length}, "
        "}";
  }
}
