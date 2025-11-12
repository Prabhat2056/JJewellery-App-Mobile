part of 'old_jewellery_bloc.dart';

final class OldJewelleryState {
  final List<OldJewelleryModel> oldJewelleryList;
  final double oldJewelleryAmount;

  OldJewelleryState({
    required this.oldJewelleryList,
    required this.oldJewelleryAmount,
  });

  factory OldJewelleryState.initial() =>
      OldJewelleryState(oldJewelleryList: [], oldJewelleryAmount: 0.00);

  OldJewelleryState copyWith(
          {required List<OldJewelleryModel> oldJewelleryList,
          required double oldJewelleryAmount}) =>
      OldJewelleryState(
          oldJewelleryList: oldJewelleryList,
          oldJewelleryAmount: oldJewelleryAmount);
}
