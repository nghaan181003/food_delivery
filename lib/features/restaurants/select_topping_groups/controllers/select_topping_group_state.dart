enum SelectToppingGroupStatus {
  initial,
  loading,
  fetched,
  linkToppingSuccess,
  failed,
}

class SelectToppingGroupState {
  final SelectToppingGroupStatus status;
  final String? message;

  SelectToppingGroupState({
    this.status = SelectToppingGroupStatus.initial,
    this.message,
  });

  SelectToppingGroupState copyWith({
    SelectToppingGroupStatus? status,
    String? message,
  }) {
    return SelectToppingGroupState(
      status: status ?? this.status,
      message: message ?? this.message,
    );
  }
}
