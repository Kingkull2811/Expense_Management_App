import 'package:viet_wallet/network/api/api_path.dart';
import 'package:viet_wallet/network/model/recurring_post_model.dart';
import 'package:viet_wallet/network/provider/provider_mixin.dart';
import 'package:viet_wallet/network/response/base_get_response.dart';
import 'package:viet_wallet/network/response/recurring_response.dart';

class RecurringProvider with ProviderMixin {
  Future<BaseGetResponse> getListRecurring(Map<String, dynamic> query) async {
    if (await isExpiredToken()) {
      return ExpiredTokenGetResponse();
    }
    try {
      final response = await dio.get(
        ApiPath.recurring,
        queryParameters: query,
        options: await defaultOptions(url: ApiPath.recurring),
      );
      // log(response.toString());

      return RecurringResponse.fromJson(response.data);
    } catch (error, stacktrace) {
      return errorGetResponse(error, stacktrace, ApiPath.recurring);
    }
  }

  Future<Object> addRecurring(Map<String, dynamic> data) async {
    if (await isExpiredToken()) {
      return ExpiredTokenGetResponse();
    }
    try {
      final response = await dio.post(
        ApiPath.recurring,
        data: data,
        options: await defaultOptions(url: ApiPath.recurring),
      );
      return RecurringPost.fromJson(response.data);
    } catch (error, stacktrace) {
      return errorGetResponse(error, stacktrace, ApiPath.recurring);
    }
  }

  Future<Object> updateRecurring(recurringID, Map<String, dynamic> data) async {
    if (await isExpiredToken()) {
      return ExpiredTokenGetResponse();
    }
    String apiUpdate = '${ApiPath.recurring}/${recurringID.toString()}';
    try {
      final response = await dio.put(
        apiUpdate,
        data: data,
        options: await defaultOptions(url: apiUpdate),
      );
      return RecurringPost.fromJson(response.data);
    } catch (error, stacktrace) {
      return errorGetResponse(error, stacktrace, apiUpdate);
    }
  }

  Future<Object> deleteRecurring(int recurringID) async {
    if (await isExpiredToken()) {
      return ExpiredTokenGetResponse();
    }
    String apiDelete = '${ApiPath.recurring}/${recurringID.toString()}';
    try {
      return await dio.delete(apiDelete,
          options: await defaultOptions(url: apiDelete));
    } catch (error, stacktrace) {
      return errorGetResponse(error, stacktrace, apiDelete);
    }
  }
}
