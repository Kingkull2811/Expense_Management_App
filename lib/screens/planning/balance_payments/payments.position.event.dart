import 'package:equatable/equatable.dart';

abstract class PaymentsPositionEvent extends Equatable {
  const PaymentsPositionEvent();

  @override
  List<Object?> get props => [];
}

class PaymentsPositionInit extends PaymentsPositionEvent {}
