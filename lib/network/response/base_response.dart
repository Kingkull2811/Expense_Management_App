import 'dart:io';

import 'package:viet_wallet/network/response/error_response.dart';

class BaseResponse {
  int? httpStatus;
  String? message;
  List<Errors>? errors;

  BaseResponse({
    this.message,
    this.httpStatus,
    this.errors,
  });

  BaseResponse.withHttpError({
    this.errors,
    this.message,
    this.httpStatus,
  });

  factory BaseResponse.fromJson(Map<String, dynamic> json) => BaseResponse(
        httpStatus: json["httpStatus"],
        message: json["message"],
        errors: json["errors"],
      );

  @override
  String toString() {
    return 'BaseResponse{httpStatus: $httpStatus, message: $message, errors: $errors}';
  }

  bool isOK() {
    return httpStatus == HttpStatus.ok;
  }

  bool isFailure() {
    return httpStatus != HttpStatus.ok;
  }
}

class ExpiredTokenResponse extends BaseResponse {
  ExpiredTokenResponse()
      : super(
            httpStatus: HttpStatus.unauthorized,
            message: 'Token Expired !',
            errors: []);
}
