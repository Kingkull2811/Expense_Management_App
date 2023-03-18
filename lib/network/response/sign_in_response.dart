import 'package:viet_wallet/network/response/user_response.dart';
import 'package:viet_wallet/network/response/base_response.dart';
import 'package:viet_wallet/network/response/error_response.dart';
import 'package:viet_wallet/utilities/utils.dart';

class SignInResponse extends BaseResponse {
  final dynamic data;

  SignInResponse({
    this.data,
    int? httpStatus,
    String? message,
    List<Errors>? errors,
  }) : super(
          httpStatus: httpStatus,
          errors: errors,
        );

  factory SignInResponse.fromJson(Map<String, dynamic> json) {
    List<Errors> errors = [];
    if(isNotNullOrEmpty(json["errors"])){
      final List<dynamic> errorsJson = json["errors"];
      errors = errorsJson.map((errorJson) => Errors.fromJson(errorJson)).toList();
    }

    return SignInResponse(
      httpStatus: json["httpStatus"],
      message: json["message"],
      data: json["data"] == null? []: UserResponse.fromJson(json["data"]),
      errors: errors,
    );
  }

  @override
  String toString() {
    return 'SignInResponse{httpStatus: $httpStatus,message: $message, error: $errors,data: $data}';
  }
}
