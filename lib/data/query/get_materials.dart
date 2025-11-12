// import 'package:dio/dio.dart';

// import 'package:jjewellery/presentation/widgets/Global/custom_toast.dart';

// import '../../endpoints.dart';
// import '../../main.dart';
// import '../../utils/color_constant.dart';

// class GetMaterials {
//   final Dio _dio = Dio();
//   Future<List> requestMaterialsFromServer() async {
//     try {
//       final Response response =
//           await _dio.get("${Endpoints.baseUrl}Materials/Get");
//       return response.data;
//     } catch (e) {
//       throw Exception("Failed to fetch payment modes: $e");
//     }
//   }

//   Future findMaterialNameInServer(String name) async {
//     try {
//       final Response response = await _dio.get(
//         "${Endpoints.baseUrl}Materials/Get",
//         queryParameters: {'name': name},
//       );
//       await db.rawQuery(
//           'INSERT INTO Materials (serverId,name) VALUES (${response.data[0]['id']}, "${response.data[0]['name']}")');
//       return response.data;
//     } on DioException catch (dioError) {
//       String errorMessage;
//       if (dioError.response != null) {
//         errorMessage = "Server Error:  ${dioError.response?.data}";
//       } else {
//         errorMessage = "Server Error: ${dioError.message}";
//       }
//       customToast(errorMessage, ColorConstant.errorColor);
//     } catch (e) {
//       customToast("An unexpected error occurred: ${e.toString()}",
//           ColorConstant.errorColor);
//     }
//   }
// }

import 'package:dio/dio.dart';
import 'package:jjewellery/Helper/service_result.dart';
import 'package:jjewellery/endpoints.dart';

import '../../main_common.dart';
import '../../models/item_materials_model.dart';

class GetMaterials {
  final Dio _dio = Dio();
  Future requestMaterialsFromServer() async {
    try {
      final Response response = await _dio.get(
        "${Endpoints.baseUrl}Materials/Get",
        options: Options(
          headers: {
            "Authorization": "Bearer ${prefs.getString("accessToken")}",
          },
        ),
      );
      if (response.data is List) {
        return ServiceResult.asSuccess(
            result: (response.data as List)
                .map((element) => ItemMaterialsModel.fromJson(element))
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
