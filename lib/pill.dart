class Pill {
  final String itemName;
  final String entpName;
  final String className;
  final String itemImage;
  bool isLiked;

  Pill({
    required this.itemName,
    required this.entpName,
    required this.className,
    required this.itemImage,
    this.isLiked = false,
  });

  // JSON 데이터를 Pill 객체로 변환하는 팩토리 메서드
  factory Pill.fromJson(Map<String, dynamic> json) {
    return Pill(
      itemName: json['ITEM_NAME'] ?? "",
      entpName: json['ENTP_NAME'] ?? "",
      className: json['CLASS_NAME'] ?? "",
      itemImage: json['ITEM_IMAGE'] ?? "",
    );
  }
}