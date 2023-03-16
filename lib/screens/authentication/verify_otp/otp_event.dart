import 'package:equatable/equatable.dart';

abstract class OtpEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class Validate extends OtpEvent {
  final bool isValidated;

  Validate({this.isValidated = false});
}

class DisplayLoading extends OtpEvent {}

class OnSuccess extends OtpEvent {}

class OnFailure extends OtpEvent {
  final String? errorMessage;

  OnFailure({this.errorMessage});
}
