import 'package:viet_wallet/bloc/api_result_state.dart';
import 'package:viet_wallet/network/model/wallet.dart';
import 'package:viet_wallet/utilities/enum/api_error_result.dart';

import '../../network/model/week_report_model.dart';

class HomePageState implements ApiResultState {
  final bool isLoading;
  final ApiError _apiError;
  final double? moneyTotal;
  final List<Wallet>? listWallet;
  final WeekReportModel? weekReport;

  HomePageState({
    this.isLoading = true,
    ApiError apiError = ApiError.noError,
    this.moneyTotal,
    this.listWallet,
    this.weekReport,
  }) : _apiError = apiError;

  @override
  ApiError get apiError => _apiError;

  HomePageState copyWith(
          {bool? isLoading,
          ApiError? apiError,
          double? moneyTotal,
          List<Wallet>? listWallet,
          WeekReportModel? weekReport}) =>
      HomePageState(
        isLoading: isLoading ?? this.isLoading,
        apiError: apiError ?? this.apiError,
        moneyTotal: moneyTotal ?? this.moneyTotal,
        listWallet: listWallet ?? this.listWallet,
        weekReport: weekReport ?? this.weekReport,
      );
}
