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
class QrResultPriceChangedEvent extends QrResultEvent {
  final QrDataModel qrData;
  QrResultPriceChangedEvent({required this.qrData});
}



//Event
class QrResultExpectedAmountChangedEvent extends QrResultEvent {
  final QrDataModel qrData;
  QrResultExpectedAmountChangedEvent(String expectedAmount,  {required this.qrData});

  //get widget => null;
  //QrResultExpectedAmountChangedEvent(this.qrData, {required QrDataModel qrData}); // Positional argument
}

// class QrResultExpectedAmountChangedEvent extends QrResultEvent {
//   final String expectedAmount;
//   QrResultExpectedAmountChangedEvent({required this.expectedAmount});
// }





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

// class QrResultResetToOriginalEvent extends QrResultEvent {
//   final QrDataModel qrData;

//   QrResultResetToOriginalEvent({required this.qrData});
// }

// class QrResultResetToOriginalEvent extends QrResultEvent {
  
//   QrResultResetToOriginalEvent();
// }
