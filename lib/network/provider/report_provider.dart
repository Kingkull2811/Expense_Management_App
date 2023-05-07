import 'package:viet_wallet/network/provider/provider_mixin.dart';

import '../api/api_path.dart';
import '../model/wallet_report_model.dart';
import '../response/base_get_response.dart';

class ReportProvider with ProviderMixin {
  Future<Object> getReportByWalletId({
    required Map<String, dynamic> queryParam,
  }) async {
    // final String apiGetReportByWalletId =
    //     ApiPath.getReportByWalletId + queryParam;
    if (await isExpiredToken()) {
      return ExpiredTokenGetResponse();
    }
    try {
      final response = await dio.get(
        ApiPath.getReportByWalletId,
        queryParameters: queryParam,
        options: await defaultOptions(url: ApiPath.getReportByWalletId),
      );
      return WalletReport.fromJson(response.data);
    } catch (error, stacktrace) {
      return errorGetResponse(error, stacktrace, ApiPath.getReportByWalletId);
    }
  }
}
