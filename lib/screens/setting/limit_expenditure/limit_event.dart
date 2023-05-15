import 'package:equatable/equatable.dart';

abstract class LimitEvent extends Equatable {
  const LimitEvent();

  @override
  List<Object?> get props => [];
}

class GetListLimitEvent extends LimitEvent {}
