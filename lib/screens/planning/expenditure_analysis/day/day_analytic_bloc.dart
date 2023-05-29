import 'package:flutter_bloc/flutter_bloc.dart';

import 'day_analytic_event.dart';
import 'day_analytic_state.dart';

class DayAnalyticBloc extends Bloc<DayAnalyticEvent, DayAnalyticState> {
  DayAnalyticBloc() : super(DayAnalyticState()) {
    on<DayAnalyticEvent>((event, emit) {
      if (event is DayAnalyticInit) {}
    });
  }
}
