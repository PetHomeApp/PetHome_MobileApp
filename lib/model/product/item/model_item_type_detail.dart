class ItemTypeDetail {
  final int idItemTypeDetail;
  final String name;
  final int count;

  ItemTypeDetail({
    required this.idItemTypeDetail,
    required this.name,
    required this.count,
  });

  factory ItemTypeDetail.fromJson(Map<String, dynamic> json) {
    return ItemTypeDetail(
      idItemTypeDetail: json['id_item_type_detail'],
      name: json['name'],
      count: json['count'],
    );
  }
}
