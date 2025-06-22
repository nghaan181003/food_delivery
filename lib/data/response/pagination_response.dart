import 'package:food_delivery_h2d/data/response/api_response.dart';

class PaginationResponse<T> extends ApiResponse {
  int? totalPages;
  int? currentPage;
  int? pageSize;
  int? totalItems;

  PaginationResponse(super.status, super.data, super.message, this.totalPages,
      this.currentPage, this.pageSize, this.totalItems);

  PaginationResponse.completed(
    T? super.data,
    super.message, {
    this.totalPages,
    this.currentPage,
    this.pageSize,
    this.totalItems,
  }) : super.completed();

  PaginationResponse.error(super.message) : super.error();

}
