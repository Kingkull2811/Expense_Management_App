import 'dart:io';

class BaseResponse {
  int? status;
  dynamic errors;

  BaseResponse({this.status, this.errors});

  BaseResponse.withHttpError({
    this.errors,
    this.status,
  });

  factory BaseResponse.fromJson(Map<String, dynamic> json) => BaseResponse(
        status: json["status"],
        errors: json["errors"],
      );

  bool isOK() {
    return status == HttpStatus.ok;
  }

  bool isFailure() {
    return status != HttpStatus.ok;
  }
}

class ExpiredTokenResponse extends BaseResponse {
  ExpiredTokenResponse()
      : super(
          status: HttpStatus.unauthorized,
          errors: 'Token Expired !',
        );
}
