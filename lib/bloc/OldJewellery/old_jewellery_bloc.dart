import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../models/old_jewellery_model.dart';

part 'old_jewellery_event.dart';
part 'old_jewellery_state.dart';

class OldJewelleryBloc extends Bloc<OldJewelleryEvent, OldJewelleryState> {
  OldJewelleryBloc() : super(OldJewelleryState.initial()) {
    on<OldJewelleryAddEvent>((event, emit) {
      final updatedList = List<OldJewelleryModel>.from(state.oldJewelleryList)
        ..add(event.oldJewelleryModel);
      final totalAmount = updatedList.fold(
          0.0, (sum, item) => sum + ((item.qtyGram * item.rate) / 11.664));

      emit(state.copyWith(
          oldJewelleryList: updatedList, oldJewelleryAmount: totalAmount));
    });
    on<OldJewelleryRemoveEvent>((event, emit) {
      final updatedList = List<OldJewelleryModel>.from(state.oldJewelleryList)
        ..remove(event.oldJewelleryModel);
      final amountToRemove =
          (event.oldJewelleryModel.qtyGram * event.oldJewelleryModel.rate) /
              11.664;
      final totalAmount = state.oldJewelleryAmount - amountToRemove;

      emit(state.copyWith(
          oldJewelleryList: updatedList, oldJewelleryAmount: totalAmount));
    });

    on<OldJewelleryClearEvent>(
        (event, emit) => emit(OldJewelleryState.initial()));
  }
}
