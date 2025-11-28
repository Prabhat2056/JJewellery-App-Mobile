part of 'qr_result_bloc.dart';

@immutable
sealed class QrResultState {
  get qrData => null;

  QrDataModel? get originalQrData => null;
  bool? get isUpdate => null;
  
  //get qrData => null;
}



final class QrResultInitial extends QrResultState {}

class QrResultInitialState extends QrResultState {
  @override
  final QrDataModel qrData;
  @override
  final bool isUpdate;
  @override
  final QrDataModel originalQrData;
  

  QrResultInitialState({
    required this.qrData,
    required this.isUpdate,
    required this.originalQrData,
  });
}

class QrResultPriceChangedState extends QrResultState {
  @override
  final QrDataModel qrData;
  QrResultPriceChangedState({required this.qrData});
}

class QrResultOnLoadingState extends QrResultState {
  final bool isLoading;
  QrResultOnLoadingState({required this.isLoading});


}
class QrResultExpectedAmountDiscountChangedState extends QrResultState {
  @override
  final QrDataModel qrData;
  @override
  final bool isUpdate;//
  @override
  final QrDataModel originalQrData;//

  //QrResultExpectedAmountDiscountChangedState({required this.qrData});
  QrResultExpectedAmountDiscountChangedState({required this.qrData, required this.isUpdate, required this.originalQrData});
}

class QrResultTotalChangedState extends QrResultState {
  @override
  final QrDataModel qrData;
  QrResultTotalChangedState({required this.qrData});
}


class QrResultExpectedAmountChangedState extends QrResultState {
  @override
  final QrDataModel qrData;
  QrResultExpectedAmountChangedState({required this.qrData});
}

// class QrResultResetToOriginalState extends QrResultState {
//   @override
//   final QrDataModel qrData;
//   @override
//   final bool isUpdate;
//   @override
//   final QrDataModel originalQrData;

//   QrResultResetToOriginalState({
//     required this.qrData,
//     required this.isUpdate,
//     required this.originalQrData,
//   });
// }

