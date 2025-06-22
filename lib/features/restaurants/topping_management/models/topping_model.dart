class ToppingModel {
  final String? id;
  final String? name;
  final num? price;
  final bool? isActive;
  final String? toppingGroupId;

  final bool isDelete;

  ToppingModel(
      {this.id,
      this.name,
      this.price,
      this.isActive = false,
      this.isDelete = false,
      this.toppingGroupId});

  bool get isNew => id == null && name == null;

  ToppingModel copyWith(
      {String? id,
      String? name,
      num? price,
      bool? isActive,
      String? toppingGroupId,
      bool? isDelete}) {
    return ToppingModel(
        id: id ?? this.id,
        name: name ?? this.name,
        price: price ?? this.price,
        isActive: isActive ?? this.isActive,
        toppingGroupId: toppingGroupId ?? this.toppingGroupId,
        isDelete: isDelete ?? this.isDelete);
  }

  factory ToppingModel.fromJson(Map<String, dynamic> json) {
    return ToppingModel(
        id: json["_id"],
        name: json["tpName"],
        price: json["tpPrice"],
        isActive: json["isActive"],
        toppingGroupId: json["tpGroupId"]);
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "tpGroupId": toppingGroupId,
      "tpName": name,
      "tpPrice": price,
      "isActive": isActive
    };
  }
}
