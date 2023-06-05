import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../network/provider/category_provider.dart';
import '../../../network/response/base_response.dart';
import '../../../network/response/category_report_response.dart';
import '../../../utilities/enum/api_error_result.dart';
import '../../../utilities/enum/enum.dart';
import '../../../utilities/screen_utilities.dart';
import 'expenditure_report_event.dart';
import 'expenditure_report_state.dart';

class ExpenditureReportBloc
    extends Bloc<ExpenditureReportEvent, ExpenditureReportState> {
  final BuildContext context;

  ExpenditureReportBloc(this.context) : super(ExpenditureReportState()) {
    on<ExpenditureReportEvent>((event, emit) async {
      final response = await CategoryProvider().getDataReport(
        type: TransactionType.expense,
      );

      if (response is CategoryReportResponse) {
        emit(state.copyWith(
          isLoading: false,
          apiError: ApiError.noError,
          listReport: response.listReport,
        ));
      } else if (response is ExpiredTokenResponse) {
        logoutIfNeed(this.context);
      } else {
        emit(state.copyWith(
          isLoading: false,
          apiError: ApiError.internalServerError,
          listReport: [],
        ));
      }
    });
  }
}
