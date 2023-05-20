import 'package:equatable/equatable.dart';

abstract class ExpenditureEvent extends Equatable {
  const ExpenditureEvent();

  @override
  List<Object?> get props => [];
}

class ExpenditureInit extends ExpenditureEvent {}
