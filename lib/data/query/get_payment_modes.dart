import 'package:dio/dio.dart';
import 'package:jjewellery/Helper/service_result.dart';
import 'package:jjewellery/endpoints.dart';
import 'package:jjewellery/models/payment_mode_model.dart';

import '../../main_common.dart';

class GetPaymentModes {
  final Dio _dio = Dio();
  Future requestPaymentModesFromServer() async {
    try {
      final Response response = await _dio.get(
        "${Endpoints.baseUrl}PaymentMode/Get",
        options: Options(
          headers: {
            "Authorization": "Bearer ${prefs.getString("accessToken")}",
          },
        ),
      );
      if (response.data is List) {
        return ServiceResult.asSuccess(
            result: (response.data as List)
                .map((element) => PaymentModeModel.fromJson(element))
                .toList());
      } else {
        return ServiceResult.asFailure(
            errorMessage: "Unexpected response format");
      }
    } catch (e) {
      return ServiceResult.asFailure(
          errorMessage: "Failed to fetch payment modes: $e");
    }
  }
}
