import 'package:equatable/equatable.dart';
import 'package:viet_wallet/network/response/error_response.dart';

abstract class SignUpEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class Validate extends SignUpEvent {
  final bool isValidated;

  Validate({this.isValidated = false});
}

class SignUpLoading extends SignUpEvent {}

class SignUpSuccess extends SignUpEvent {
  final String message;

  SignUpSuccess({required this.message});
}

class SignUpFailure extends SignUpEvent {
  final List<Errors>? errors;

  SignUpFailure({required this.errors});
}
