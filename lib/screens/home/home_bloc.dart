import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'home_event.dart';
import 'home_state.dart';

class HomePageBloc extends Bloc<HomePageEvent, HomePageState>{
  HomePageBloc(BuildContext context): super(HomePageState()){
    on((event, emit) async{

    });
  }
}