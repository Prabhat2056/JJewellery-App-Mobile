import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jjewellery/bloc/OldJewellery/old_jewellery_bloc.dart';

import '../../helper/service_result.dart';

import '../../endpoints.dart';
import '../../main_common.dart';
import '../../models/qr_data_model.dart';

Future addBill(bloc, context) async {
  List billItems = [];
  List<QrDataModel> jewelleryOrders = bloc.state.jewelleryOrders;
  billItems = jewelleryOrders.map((e) => e.toJson()).toList();
  List paymentModes = bloc.state.paymentModes;
  List newPaymentModes = paymentModes
      .where((p) => p.amount != 0)
      .map((e) =>
          {"id": 0, "billId": 0, "paymentModeId": e.id, "amount": e.amount})
      .toList();
  List oldJewellery =
      BlocProvider.of<OldJewelleryBloc>(context).state.oldJewelleryList.isEmpty
          ? [
              {
                "id": 0,
                "itemId": 0,
                "materialId": 0,
                "rate": 0,
                "customerQty": 0,
                "deductionQty": 0
              }
            ]
          : BlocProvider.of<OldJewelleryBloc>(context)
              .state
              .oldJewelleryList
              .map((oj) => {
                    "id": 0,
                    "itemId": oj.itemId,
                    "materialId": oj.materialId,
                    "rate": oj.rate,
                    "customerQty": oj.qtyGram,
                    "deductionQty": oj.wasteGram
                  })
              .toList();

  var body = {
    "id": 0,
    "amount": bloc.state.totalAmount,
    "discount": bloc.state.discount ?? 0,
    "salesUserId": bloc.state.cashiers
        .firstWhere((c) => c.name == bloc.state.selectedCashier)
        .id,
    "billItems": billItems,
    "paymentModes": newPaymentModes,
    "customer": {
      "id": 0,
      "name": bloc.state.customerName,
      "address": bloc.state.customerAddress,
      "phone": bloc.state.customerPhone,
      "pan": bloc.state.customerPan.isEmpty ? "" : bloc.state.customerPan,
    },
    'oldJewellery': oldJewellery
  };

  try {
    Response response = await Dio().post(
      "${Endpoints.baseUrl}MBill/Add",
      data: body,
      options: Options(
        headers: {
          "Authorization": "Bearer ${prefs.getString("accessToken")}",
        },
      ),
    );
    if (response.statusCode == 403) {
      return ServiceResult.asFailure(
        errorMessage: "You don't have permission to perform this action",
      );
    }
    BlocProvider.of<OldJewelleryBloc>(context).add(OldJewelleryClearEvent());
    return ServiceResult.asSuccess(result: response.data);
  } on DioException catch (e) {
    if (e.response?.statusCode == 403) {
      return ServiceResult.asFailure(
        errorMessage: "You don't have permission to perform this action",
      );
    }
    return ServiceResult.asFailure(
      errorMessage: e.message,
    );
  } catch (e) {
    return ServiceResult.asFailure(
      errorMessage: e.toString(),
    );
  }
}
