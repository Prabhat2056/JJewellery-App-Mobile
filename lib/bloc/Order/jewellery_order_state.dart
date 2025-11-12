part of 'jewellery_order_bloc.dart';

final class JewelleryOrderLoadedState {
  final List<QrDataModel> jewelleryOrders;
  List<PaymentModeModel> paymentModes = [];
  // List<ItemMaterialsModel> items = [];
  // List<ItemMaterialsModel> materials = [];
  int totalAmount = 0;
  int totalBill = 0;
  int discount = 0;
  int oldJewellery = 0;
  final List<CashierModel> cashiers;
  String? selectedCashier;

  String customerName;
  String customerAddress;
  String customerPhone;
  String customerPan;

  bool isCashierEmpty;

  JewelleryOrderLoadedState({
    required this.jewelleryOrders,
    this.paymentModes = const [],
    // this.items = const [],
    // this.materials = const [],
    this.totalAmount = 0,
    this.totalBill = 0,
    this.discount = 0,
    this.oldJewellery = 0,
    required this.cashiers,
    this.selectedCashier,
    required this.customerName,
    required this.customerAddress,
    required this.customerPhone,
    required this.customerPan,
    required this.isCashierEmpty,
  });

  factory JewelleryOrderLoadedState.initial() {
    return JewelleryOrderLoadedState(
      jewelleryOrders: const [],
      paymentModes: const [],
      // items: const [],
      // materials: const [],
      cashiers: const [],
      selectedCashier: null,
      totalAmount: 0,
      totalBill: 0,
      discount: 0,
      oldJewellery: 0,
      customerName: '',
      customerAddress: '',
      customerPhone: '',
      customerPan: '',
      isCashierEmpty: false,
    );
  }

  JewelleryOrderLoadedState copyWith({
    List<QrDataModel>? jewelleryOrders,
    List<PaymentModeModel>? paymentModes,
    List<CashierModel>? cashiers,
    // List<ItemMaterialsModel>? items,
    // List<ItemMaterialsModel>? materials,
    String? selectedCashier,
    int? totalAmount,
    int? totalBill,
    int? discount,
    int? oldJewellery,
    bool? clearSelectedCashier,
    String? customerName,
    String? customerAddress,
    String? customerPhone,
    String? customerPan,
    bool? isCashierEmpty,
  }) {
    return JewelleryOrderLoadedState(
      jewelleryOrders: jewelleryOrders ?? this.jewelleryOrders,
      paymentModes: paymentModes ?? this.paymentModes,
      // items: items ?? this.items,
      // materials: materials ?? this.materials,
      cashiers: cashiers ?? this.cashiers,
      totalAmount: totalAmount ?? this.totalAmount,
      totalBill: totalBill ?? this.totalBill,
      discount: discount ?? this.discount,
      oldJewellery: oldJewellery ?? this.oldJewellery,
      selectedCashier: clearSelectedCashier == true
          ? null
          : selectedCashier ?? this.selectedCashier,
      customerName: customerName ?? this.customerName,
      customerAddress: customerAddress ?? this.customerAddress,
      customerPhone: customerPhone ?? this.customerPhone,
      customerPan: customerPan ?? this.customerPan,
      isCashierEmpty: isCashierEmpty ?? this.isCashierEmpty,
    );
  }
}
