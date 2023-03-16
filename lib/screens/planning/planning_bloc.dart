import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'planning_event.dart';
import 'planning_state.dart';

class PlanningBloc extends Bloc<PlanningEvent,PlanningState>{
  PlanningBloc(BuildContext context): super(PlanningState()){
    on((event, emit) async{

    });
  }
}