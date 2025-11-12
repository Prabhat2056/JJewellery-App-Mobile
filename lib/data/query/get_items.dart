// import 'package:dio/dio.dart';

// import 'package:jjewellery/presentation/widgets/Global/custom_snackbar.dart';
// import 'package:jjewellery/presentation/widgets/Global/custom_toast.dart';
// import 'package:jjewellery/utils/color_constant.dart';

// import '../../endpoints.dart';
// import '../../main.dart';

// class GetItems {
//   final Dio _dio = Dio();
//   Future<List> requestItemsFromServer() async {
//     try {
//       final Response response = await _dio.get("${Endpoints.baseUrl}Item/Get");
//       return response.data;
//     } catch (e) {
//       throw Exception("Failed to fetch items: $e");
//     }
//   }

//   Future findItemCodeInServer(String code) async {
//     try {
//       final Response response = await _dio.get(
//         "${Endpoints.baseUrl}Item/Get",
//         queryParameters: {'code': code},
//       );

//       await db.rawQuery(
//           'INSERT INTO Items (serverId,name,code) VALUES (${response.data[0]['id']}, "${response.data[0]['name']}", "${response.data[0]['code']}")');
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
//       customSnackBar("An unexpected error occurred: ${e.toString()}",
//           ColorConstant.errorColor);
//     }
//   }
// }

import 'package:dio/dio.dart';
import 'package:jjewellery/Helper/service_result.dart';
import 'package:jjewellery/data/query/get_materials.dart';
import 'package:jjewellery/endpoints.dart';
import '../../main_common.dart';
import '../../models/item_materials_model.dart';

class GetItems {
  final Dio _dio = Dio();
  Future requestItemsFromServer() async {
    try {
      final url = "${Endpoints.baseUrl}Item/Get";

      final Response response = await _dio.get(
        url,
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

class ItemsMaterialsDataRepository {
  static final ItemsMaterialsDataRepository _itemsMaterialsDataRepository =
      ItemsMaterialsDataRepository._internal();
  factory ItemsMaterialsDataRepository() => _itemsMaterialsDataRepository;
  ItemsMaterialsDataRepository._internal();

  GetItems getItems = GetItems();
  GetMaterials getMaterials = GetMaterials();

  List<ItemMaterialsModel> items = [];
  List<ItemMaterialsModel> materials = [];

  Future<bool> initialize() async {
    var i = await getItems.requestItemsFromServer();
    // print(i);
    if (i.isSuccess == false) {
      return false;
    }
    var m = await getMaterials.requestMaterialsFromServer();
    if (m.isSuccess == false) {
      return false;
    }
    items = i.result as List<ItemMaterialsModel>;
    materials = m.result as List<ItemMaterialsModel>;
    return true;
  }
}
