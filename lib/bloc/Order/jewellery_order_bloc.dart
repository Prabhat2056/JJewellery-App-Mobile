import 'dart:async';

import 'package:bloc/bloc.dart';

import 'package:flutter/material.dart';
import 'package:jjewellery/data/query/get_cashier.dart';
import 'package:jjewellery/data/query/get_payment_modes.dart';

import 'package:jjewellery/models/cashier.dart';
import 'package:meta/meta.dart';

import '../../data/query/get_items.dart';
import '../../data/query/get_materials.dart';
import '../../models/payment_mode_model.dart';
import '../../models/qr_data_model.dart';

part 'jewellery_order_event.dart';
part 'jewellery_order_state.dart';

class JewelleryOrderBloc
    extends Bloc<JewelleryOrderEvent, JewelleryOrderLoadedState> {
  GetItems getItems = GetItems();
  GetMaterials getMaterials = GetMaterials();
  double stringToDouble(String value) {
    String sanitizedValue = value.replaceAll(',', '').trim();
    return double.tryParse(sanitizedValue) ?? 0.0;
  }

  int calcTotalBill(orders) {
    var value =
        orders.fold(0.0, (sum, order) => sum + stringToDouble(order.price));
    return int.parse(value.toStringAsFixed(0));
  }

  JewelleryOrderBloc() : super(JewelleryOrderLoadedState.initial()) {
    on<AddJewelleryOrderEvent>((event, emit) {
      final idExists = state.jewelleryOrders
          .any((element) => element.id == event.orderItem.id);
      if (idExists) {
        state.jewelleryOrders.remove(state.jewelleryOrders
            .firstWhere((data) => data.id == event.orderItem.id));
      }
      final updatedOrders = List<QrDataModel>.from(state.jewelleryOrders)
        ..add(event.orderItem);

      int updatedBill = calcTotalBill(updatedOrders);

      emit(state.copyWith(
          jewelleryOrders: updatedOrders, totalBill: updatedBill));
    });

    on<RemoveJewelleryOrderEvent>((event, emit) {
      final updatedOrders = List<QrDataModel>.from(state.jewelleryOrders)
        ..remove(event.orderItem);
      int updatedBill = calcTotalBill(updatedOrders);
      emit(state.copyWith(
          jewelleryOrders: updatedOrders, totalBill: updatedBill));
    });

    on<ClearJewelleryOrderEvent>((event, emit) {
      for (var pm in state.paymentModes) {
        pm.amount = 0;
      }
      emit(state.copyWith(
        jewelleryOrders: [],
        clearSelectedCashier: true,
        paymentModes: state.paymentModes,
        totalBill: 0,
        totalAmount: 0,
        discount: 0,
        oldJewellery: 0,
        customerName: '',
        customerAddress: '',
        customerPan: '',
        customerPhone: '',
        isCashierEmpty: false,
      ));
    });

    on<PaymentModeLoadEvent>((event, emit) async {
      GetPaymentModes getPaymentModes = GetPaymentModes();
      GetCashier getCashier = GetCashier();
      // if (prefs.getBool("IsSetUpDone") == false ||
      //     prefs.containsKey("IsSetUpDone") == false) {
      //   await db.transaction((txn) async {
      // List items = await getItems.requestItemsFromServer();
      // List materials = await getMaterials.requestMaterialsFromServer();
      // if (items.isEmpty || materials.isEmpty) return;
      // for (int i = 0; i < items.length; i++) {
      //   await txn.rawInsert(
      //     'INSERT INTO Items (serverId,name,code) VALUES (${items[i]['id']}, "${items[i]['name']}", "${items[i]['code']}")',
      //   );
      // }
      // for (int i = 0; i < materials.length; i++) {
      //   await txn.rawInsert(
      //     'INSERT INTO Materials (serverId,name) VALUES (${materials[i]['id']}, "${materials[i]['name']}")',
      //   );
      // }
      //     prefs.setBool("IsSetUpDone", true);
      //   });
      // }
      // print("I am loading payment modes and cashier from server");
      var paymentModes = await getPaymentModes.requestPaymentModesFromServer();
      if (paymentModes.isSuccess == false) {
        return;
      }
      var cashiers = await getCashier.requestCashierFromServer();
      if (cashiers.isSuccess == false) {
        return;
      }
      emit(state.copyWith(
        paymentModes: paymentModes.result as List<PaymentModeModel>,
        cashiers: cashiers.result as List<CashierModel>,
      ));
    });
    // on<ItemMaterialsLoadEvent>(
    //   (event, emit) async {
    //     GetItems getItems = GetItems();
    //     GetMaterials getMaterials = GetMaterials();
    //     var items = await getItems.requestItemsFromServer();
    //     if (items.isSuccess == false) {
    //       return;
    //     }
    //     var materials = await getMaterials.requestMaterialsFromServer();
    //     if (materials.isSuccess == false) {
    //       return;
    //     }
    //     emit(state.copyWith(
    //       items: items.result as List<ItemMaterialsModel>,
    //       materials: materials.result as List<ItemMaterialsModel>,
    //     ));
    //   },
    // );
    on<UpdatePaymentChangedEvent>((event, emit) {
      int amount = int.parse(event.value.isEmpty ? "0" : event.value);
      // Update the payment details and calculate the total amount in one loop
      int totalAmount = 0;
      for (var pm in state.paymentModes) {
        if (pm.id == event.paymentModeId) {
          pm.amount = amount;
        }
        totalAmount += pm.amount; // Ensure to handle null safely
      }

      // Emit the new state with the updated total amount and payment details
      emit(state.copyWith(
          totalAmount: totalAmount, paymentModes: state.paymentModes));
    });

    on<OnCashierChangedEvent>((event, emit) {
      emit(state.copyWith(selectedCashier: event.selectedCashier));
    });
    on<CustomerNameChangedEvent>((event, emit) {
      emit(state.copyWith(customerName: event.customerName));
    });
    on<CustomerAddressChangedEvent>((event, emit) {
      emit(state.copyWith(customerAddress: event.customerAddress));
    });
    on<CustomerPhoneChangedEvent>((event, emit) {
      emit(state.copyWith(customerPhone: event.customerPhone));
    });
    on<CustomerPanChangedEvent>((event, emit) {
      emit(state.copyWith(customerPan: event.customerPan));
    });
    on<CashierEmptyEvent>((event, emit) async {
      emit(state.copyWith(isCashierEmpty: true));
      await Future.delayed(const Duration(seconds: 3));
      emit(state.copyWith(isCashierEmpty: false));
    });

    on<DiscountChangedEvent>((event, emit) {
      emit(state.copyWith(discount: int.parse(event.discount)));
    });
    on<OldJewelleryChangedEvent>((event, emit) {
      emit(state.copyWith(oldJewellery: int.parse(event.oldJewellery)));
    });
  }
}
