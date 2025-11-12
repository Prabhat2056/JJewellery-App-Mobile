part of 'jewellery_order_bloc.dart';

@immutable
sealed class JewelleryOrderEvent {}

class AddJewelleryOrderEvent extends JewelleryOrderEvent {
  final QrDataModel orderItem;

  AddJewelleryOrderEvent(this.orderItem);
}

class RemoveJewelleryOrderEvent extends JewelleryOrderEvent {
  final QrDataModel orderItem;

  RemoveJewelleryOrderEvent(this.orderItem);
}

class ClearJewelleryOrderEvent extends JewelleryOrderEvent {}

class PaymentModeLoadEvent extends JewelleryOrderEvent {}

class UpdatePaymentChangedEvent extends JewelleryOrderEvent {
  final int paymentModeId;
  final String value;
  UpdatePaymentChangedEvent({required this.paymentModeId, required this.value});
}

class OnCashierChangedEvent extends JewelleryOrderEvent {
  final String selectedCashier;
  OnCashierChangedEvent(this.selectedCashier);
}

class PlaceOrderEvent extends JewelleryOrderEvent {}

class CustomerNameChangedEvent extends JewelleryOrderEvent {
  final String customerName;
  CustomerNameChangedEvent(this.customerName);
}

class CustomerAddressChangedEvent extends JewelleryOrderEvent {
  final String customerAddress;
  CustomerAddressChangedEvent(this.customerAddress);
}

class CustomerPhoneChangedEvent extends JewelleryOrderEvent {
  final String customerPhone;
  CustomerPhoneChangedEvent(this.customerPhone);
}

class CustomerPanChangedEvent extends JewelleryOrderEvent {
  final String customerPan;
  CustomerPanChangedEvent(this.customerPan);
}

class CashierEmptyEvent extends JewelleryOrderEvent {}

// class ItemMaterialsLoadEvent extends JewelleryOrderEvent {}

class DiscountChangedEvent extends JewelleryOrderEvent {
  final String discount;
  DiscountChangedEvent(this.discount);
}

class OldJewelleryChangedEvent extends JewelleryOrderEvent {
  final String oldJewellery;
  OldJewelleryChangedEvent(this.oldJewellery);
}
