import '../../utilities/utils.dart';

class CategoryModel {
  final int? id;
  final String? name;
  final int? parentId;
  final String? description;
  final int? logoImageID;
  final String? logoImageUrl;
  final List<ContentItem>? childCategory;
  final String? categoryType;
  final String? createdAt;
  final int? createdBy;
  final bool pay;

  CategoryModel({
    this.id,
    this.name,
    this.parentId,
    this.description,
    this.logoImageID,
    this.logoImageUrl,
    this.childCategory,
    this.categoryType,
    this.createdAt,
    this.createdBy,
    this.pay = false,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'],
      name: json['name'],
      parentId: json['parentId'],
      description: json['description'],
      logoImageID: json['logoImageID'],
      logoImageUrl: json['logoImage'],
      childCategory: isNullOrEmpty(json['childCategory'])
          ? []
          : List<ContentItem>.generate(
              json['childCategory'].length,
              (index) => ContentItem.fromJson(json['childCategory'][index]),
            ),
      categoryType: json['categoryType'],
      createdAt: json['createdAt'],
      createdBy: json['createdBy'],
      pay: json['pay'],
    );
  }
}

class ContentItem {
  final int? id;
  final String? name;
  final int? parentId;
  final String? description;
  final int? logoImageID;
  final String? logoImageUrl;
  final List<ContentItem>? childCategory;
  final String? categoryType;
  final String? createdAt;
  final int? createdBy;
  final bool pay;

  ContentItem({
    this.id,
    this.name,
    this.parentId,
    this.description,
    this.logoImageID,
    this.logoImageUrl,
    this.childCategory,
    this.categoryType,
    this.createdAt,
    this.createdBy,
    this.pay = false,
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

  @override
  String toString() {
    return 'ContentItem{id: $id, name: $name, parentId: $parentId, description: $description, logoImageUrl: $logoImageUrl, childCategory: $childCategory, categoryType: $categoryType}';
  }
}
