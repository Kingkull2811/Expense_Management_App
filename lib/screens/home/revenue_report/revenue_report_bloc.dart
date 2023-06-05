import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:viet_wallet/screens/home/revenue_report/revenue_report_event.dart';
import 'package:viet_wallet/screens/home/revenue_report/revenue_report_state.dart';

import '../../../network/provider/category_provider.dart';
import '../../../network/response/base_response.dart';
import '../../../network/response/category_report_response.dart';
import '../../../utilities/enum/api_error_result.dart';
import '../../../utilities/enum/enum.dart';
import '../../../utilities/screen_utilities.dart';

class RevenueReportBloc extends Bloc<RevenueReportEvent, RevenueReportState> {
  final BuildContext context;

  RevenueReportBloc(this.context) : super(RevenueReportState()) {
    on<RevenueReportEvent>((event, emit) async {
      final response = await CategoryProvider().getDataReport(
        type: TransactionType.income,
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
