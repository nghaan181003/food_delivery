class ScheduleHelper {
  static String translateDayToVietnamese(String day) {
    switch (day.toLowerCase()) {
      case 'monday':
        return 'Thứ Hai';
      case 'tuesday':
        return 'Thứ Ba';
      case 'wednesday':
        return 'Thứ Tư';
      case 'thursday':
        return 'Thứ Năm';
      case 'friday':
        return 'Thứ Sáu';
      case 'saturday':
        return 'Thứ Bảy';
      case 'sunday':
        return 'Chủ Nhật';
      default:
        return day;
    }
  }
}
