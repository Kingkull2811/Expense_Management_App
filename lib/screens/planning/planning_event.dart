import 'package:equatable/equatable.dart';

abstract class PlanningEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class InitialEvent extends PlanningEvent {}
