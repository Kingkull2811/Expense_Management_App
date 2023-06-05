import 'package:viet_wallet/network/response/base_response.dart';

import '../../utilities/utils.dart';
import '../model/category_report_model.dart';
import 'error_response.dart';

class CategoryReportResponse extends BaseResponse {
  final List<CategoryReportModel>? listReport;

  CategoryReportResponse({
    required this.listReport,
    int? httpStatus,
    String? message,
    List<Errors>? errors,
  }) : super(
          httpStatus: httpStatus,
          errors: errors,
        );

  factory CategoryReportResponse.fromJson(Map<String, dynamic> json) {
    List<Errors> errors = [];
    if (isNotNullOrEmpty(json["errors"])) {
      final List<dynamic> errorsJson = json["errors"];
      errors =
          errorsJson.map((errorJson) => Errors.fromJson(errorJson)).toList();
    }

    return CategoryReportResponse(
      httpStatus: json["httpStatus"],
      message: json["message"],
      listReport: json['data'] == null
          ? []
          : List<CategoryReportModel>.generate(
              json['data'].length,
              (index) => CategoryReportModel.fromJson(json['data'][index]),
            ),
      errors: errors,
    );
  }
}
