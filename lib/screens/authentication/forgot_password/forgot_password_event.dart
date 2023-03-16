import 'package:equatable/equatable.dart';

abstract class ForgotPasswordEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class Validate extends ForgotPasswordEvent {
  final bool isValidated;

  Validate({this.isValidated = false});
}

class DisplayLoading extends ForgotPasswordEvent {}

class OnSuccess extends ForgotPasswordEvent {}

class OnFailure extends ForgotPasswordEvent {
  final String? errorMessage;

  OnFailure({this.errorMessage});
}
