import 'package:viet_wallet/network/response/error_response.dart';

class SignUpResult {
  final bool isSuccess;
  final String? message;
  final List<Errors>? errors;

  SignUpResult({
    this.isSuccess = false,
    this.message,
    this.errors,
  });
}
