import 'package:dio/dio.dart';
import 'package:jjewellery/helper/helper_functions.dart';
import 'package:jjewellery/main_common.dart';

import '../endpoints.dart';

class HelperHandleToken {
  final String token = prefs.getString("accessToken")!;
  Future<bool> isValid() async {
    if (token.isEmpty || token == "") {
      return false;
    }
    if (isTokenExpired(token: token)) {
      try {
        final Response response = await Dio().post(
            "${Endpoints.baseUrl}Authentication/LoginWithRefreshToken",
            data: {"refreshToken": prefs.get("refreshToken")});
        if (response.statusCode == 401) {
          prefs.setString("accessToken", "");
          prefs.setString("refreshToken", "");
          return false;
        } else if (response.statusCode == 200) {
          prefs.setString("accessToken", response.data["accessToken"]);
          return true;
        } else {
          return false;
        }
      } on DioException catch (e) {
        if (e.response?.statusCode == 401) {
          prefs.setString("accessToken", "");
          prefs.setString("refreshToken", "");
          return false;
        } else {
          return false;
        }
      } catch (e) {
        throw Exception("Failed to fetch items: $e");
      }
    } else {
      return true;
    }
  }
}
