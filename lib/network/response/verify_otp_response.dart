import 'package:viet_wallet/network/response/base_response.dart';
import 'package:viet_wallet/utilities/utils.dart';

import 'error_response.dart';

class VerifyOtpResponse extends BaseResponse{

  VerifyOtpResponse({
    httpStatus,
    String? message,
    List<Errors>? errors,
  }) : super(
    httpStatus: httpStatus,
    message: message,
    errors: errors,
  );

  factory VerifyOtpResponse.fromJson(Map<String, dynamic> json) {
    List<Errors> errors = [];
    if(isNotNullOrEmpty(json["errors"])){
      final List<dynamic> errorsJson = json["errors"];
      errors = errorsJson.map((errorJson) => Errors.fromJson(errorJson)).toList();
    }

    return VerifyOtpResponse(
      httpStatus: json['httpStatus'],
      message: json['message'],
      errors: errors,
    );
  }

  @override
  String toString() {
    return 'ForgotPasswordResponse{httpStatus: $httpStatus, message: $message, error: $errors}';
  }
}