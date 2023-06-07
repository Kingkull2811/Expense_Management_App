import 'package:viet_wallet/network/response/base_response.dart';

import '../../utilities/utils.dart';
import '../model/refresh_token_model.dart';
import 'error_response.dart';

class RefreshTokenResponse extends BaseResponse {
  final RefreshTokenModel data;

  RefreshTokenResponse({
    required this.data,
    int? httpStatus,
    String? message,
    List<Errors>? errors,
  }) : super(
          httpStatus: httpStatus,
          errors: errors,
        );

  factory RefreshTokenResponse.fromJson(Map<String, dynamic> json) {
    List<Errors> errors = [];
    if (isNotNullOrEmpty(json["errors"])) {
      final List<dynamic> errorsJson = json["errors"];
      errors =
          errorsJson.map((errorJson) => Errors.fromJson(errorJson)).toList();
    }

    return RefreshTokenResponse(
      httpStatus: json["httpStatus"],
      message: json["message"],
      data: RefreshTokenModel.fromJson(json["data"]),
      errors: errors,
    );
  }

  @override
  String toString() {
    return 'RefreshTokenResponse{data: $data}';
  }
}
