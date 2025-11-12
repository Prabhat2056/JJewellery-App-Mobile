part of 'old_jewellery_bloc.dart';

@immutable
sealed class OldJewelleryEvent {}

class OldJewelleryAddEvent extends OldJewelleryEvent {
  final OldJewelleryModel oldJewelleryModel;

  OldJewelleryAddEvent({required this.oldJewelleryModel});
}

class OldJewelleryRemoveEvent extends OldJewelleryEvent {
  final OldJewelleryModel oldJewelleryModel;

  OldJewelleryRemoveEvent({required this.oldJewelleryModel});
}

class OldJewelleryClearEvent extends OldJewelleryEvent {
  OldJewelleryClearEvent();
}
