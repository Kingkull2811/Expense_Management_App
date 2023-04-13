import 'package:viet_wallet/network/model/category_model.dart';

import 'base_get_response.dart';

class GetCategoryResponse extends BaseGetResponse {
  List<ContentItem>? listCategory;

  GetCategoryResponse({
    this.listCategory,
    int? pageNumber,
    int? pageSize,
    int? totalRecord,
    int? status,
    String? error,
  }) : super(
          pageNumber: pageNumber,
          pageSize: pageSize,
          totalRecord: totalRecord,
          status: status,
          error: error,
        );

  factory GetCategoryResponse.fromJson(Map<String, dynamic> json) {
    return GetCategoryResponse(
      listCategory: json['content'] == null
          ? []
          : List.generate(
              json['content'].length,
              (index) => ContentItem.fromJson(json['content'][index]),
            ),
      pageNumber: json['pageNumber'],
      pageSize: json['pageSize'],
      totalRecord: json['totalRecord'],
      status: json['status'],
      error: json['error'],
    );
  }
}
