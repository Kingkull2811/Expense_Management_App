class ContentItem {
  final int id;
  final String name;
  final int parentId;
  final String description;
  final int logoImageID;
  final String logoImageUrl;
  final dynamic childCategory; // could be null or a list of child categories
  final String categoryType;
  final String createdAt;
  final int createdBy;
  final bool pay;

  ContentItem({
    required this.id,
    required this.name,
    required this.parentId,
    required this.description,
    required this.logoImageID,
    required this.logoImageUrl,
    required this.childCategory,
    required this.categoryType,
    required this.createdAt,
    required this.createdBy,
    required this.pay,
  });

  factory ContentItem.fromJson(Map<String, dynamic> json) {
    return ContentItem(
      id: json['id'],
      name: json['name'],
      parentId: json['parentId'],
      description: json['description'],
      logoImageID: json['logoImageID'],
      logoImageUrl: json['logoImage'],
      childCategory: json['childCategory'],
      categoryType: json['categoryType'],
      createdAt: json['createdAt'],
      createdBy: json['createdBy'],
      pay: json['pay'],
    );
  }
}
