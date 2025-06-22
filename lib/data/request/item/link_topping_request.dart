class LinkToppingRequest {
  final String? itemId;
  final List<String> toppingGroupIds;

  LinkToppingRequest({
    this.itemId,
    this.toppingGroupIds = const [],
  });

  Map<String, dynamic> toJson() {
    return {
      // 'itemid': itemid,
      'toppingGroupIds': toppingGroupIds,
    };
  }
}
