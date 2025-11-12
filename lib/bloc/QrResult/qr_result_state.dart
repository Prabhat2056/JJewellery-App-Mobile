part of 'qr_result_bloc.dart';

@immutable
sealed class QrResultState {}

final class QrResultInitial extends QrResultState {}

class QrResultInitialState extends QrResultState {
  final QrDataModel qrData;
  final bool isUpdate;
  final QrDataModel originalQrData;

  QrResultInitialState({
    required this.qrData,
    required this.isUpdate,
    required this.originalQrData,
  });
}

class QrResultPriceChangedState extends QrResultState {
  final QrDataModel qrData;
  QrResultPriceChangedState({required this.qrData});
}

class QrResultOnLoadingState extends QrResultState {
  final bool isLoading;
  QrResultOnLoadingState({required this.isLoading});
}
