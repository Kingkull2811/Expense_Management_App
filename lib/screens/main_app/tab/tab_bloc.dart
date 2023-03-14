import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:viet_wallet/screens/main_app/tab/tab_event.dart';

class TabBloc extends Bloc<TabEvent, AppTab> {
  final AppTab initTab;

  TabBloc({
    this.initTab = AppTab.home,
  }) : super(initTab) {
    on((event, emit) {
      if (event is TabUpdated) {
        emit(event.tab);
      }
    });
  }
}