import 'package:dio/dio.dart';
import 'package:viet_wallet/network/api/api_path.dart';
import 'package:viet_wallet/network/provider/provider_mixin.dart';

import '../response/base_get_response.dart';
import '../response/get_category_response.dart';

class CategoryProvider with ProviderMixin {
  Future<BaseGetResponse> getListCategory() async {
    if (await isExpiredToken()) {
      return ExpiredTokenGetResponse();
    }

    try {
      Options options = await defaultOptions(
        url: ApiPath.getListCategory,
      );

      final response = await dio.get(
        ApiPath.getListCategory,
        options: options,
      );
      // log('response: ${response.toString()}');

      return GetCategoryResponse.fromJson(response.data);
    } catch (error, stacktrace) {
      return errorGetResponse(error, stacktrace, ApiPath.getListCategory);
    }
  }
}
