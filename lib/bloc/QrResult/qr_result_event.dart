part of 'qr_result_bloc.dart';

@immutable
sealed class QrResultEvent {}

class QrResultInitialEvent extends QrResultEvent {
  final QrDataModel qrData;
  // final List karatSettings;
  final bool isUpdate;

  QrResultInitialEvent({
    required this.qrData,
    // required this.karatSettings,
    required this.isUpdate,
  });
}

class QrResultNetWeightChangedEvent extends QrResultEvent {
  final QrDataModel qrData;
  QrResultNetWeightChangedEvent({required this.qrData});
}

class QrResultRateChangedEvent extends QrResultEvent {
  final QrDataModel qrData;
  QrResultRateChangedEvent({required this.qrData});
}

class QrResultJartiGramChangedEvent extends QrResultEvent {
  final QrDataModel qrData;
  QrResultJartiGramChangedEvent({required this.qrData});
}

class QrResultJartiLalChangedEvent extends QrResultEvent {
  final QrDataModel qrData;
  QrResultJartiLalChangedEvent({required this.qrData});
}

class QrResultJartiPercentageChangedEvent extends QrResultEvent {
  final QrDataModel qrData;
  QrResultJartiPercentageChangedEvent({required this.qrData});
}

class QrResultJyalaChangedEvent extends QrResultEvent {
  final QrDataModel qrData;
  QrResultJyalaChangedEvent({required this.qrData});
}

class QrResultJyalaPercentageChangedEvent extends QrResultEvent {
  final QrDataModel qrData;
  QrResultJyalaPercentageChangedEvent({required this.qrData});
}

class QrResultExpectedAmountChangedEvent extends QrResultEvent {
  final QrDataModel qrData;
  QrResultExpectedAmountChangedEvent({required this.qrData});
}

class QrResultItemChangedEvent extends QrResultEvent {
  final QrDataModel qrData;
  QrResultItemChangedEvent({
    required this.qrData,
  });
}


class QrResultExpectedAmountDiscountChangedEvent extends QrResultEvent {
  final QrDataModel qrData;
  
  QrResultExpectedAmountDiscountChangedEvent({required this.qrData});
}


class QrResultOnLoadingEvent extends QrResultEvent {
  final bool isLoading;

  QrResultOnLoadingEvent({required this.isLoading});
}
