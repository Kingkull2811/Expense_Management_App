import 'package:equatable/equatable.dart';

abstract class SignInEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class ValidateForm extends SignInEvent {
  final bool isValidate;

  ValidateForm({this.isValidate = false});
}

class DisplayLoading extends SignInEvent {}

class SignInSuccess extends SignInEvent {}

class SignInFailure extends SignInEvent {
  final String? errorMessage;

  SignInFailure({this.errorMessage});
}
