import 'package:viet_wallet/network/model/category_model.dart';
import 'package:viet_wallet/utilities/utils.dart';

import 'base_get_response.dart';

class GetCategoryResponse extends BaseGetResponse {
  List<CategoryModel>? listCategory;

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
      listCategory: isNullOrEmpty(json['content'])
          ? []
          : List<CategoryModel>.generate(
              json['content'].length,
              (index) => CategoryModel.fromJson(json['content'][index]),
            ),
      pageNumber: json['pageNumber'],
      pageSize: json['pageSize'],
      totalRecord: json['totalRecord'],
      status: json['status'],
      error: json['error'],
    );
  }

  @override
  String toString() {
    return 'GetCategoryResponse{listCategory: $listCategory}';
  }
}
