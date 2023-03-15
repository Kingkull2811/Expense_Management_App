import 'package:viet_wallet/network/response/error_response.dart';

class BaseResult{
  final bool isSuccess;
  final String? message;
  final List<Errors>? errors;

  BaseResult({
    this.isSuccess = false,
    this.message,
    this.errors,
});

  @override
  String toString() {
    return 'BaseResult{isSuccess: $isSuccess,message $message,errors: $errors}';
  }
}