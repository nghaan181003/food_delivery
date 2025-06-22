String getDriverStatusText(String? status) {
  const statusMapping = {
    'new': 'Đơn mới',
    'waiting': 'Đang chờ',
    'heading_to_rest': 'Đang tới quán',
    'preparing': 'Đang chuẩn bị',
    'delivering': 'Đang giao',
    'delivered': 'Đã giao',
    'completed': 'Đã hoàn thành',
    'cancelled': 'Đã hủy',
  };

  return statusMapping[status] ?? 'Trạng thái không xác định';
}
