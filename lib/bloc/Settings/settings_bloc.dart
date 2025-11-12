import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../main_common.dart';
import '../../models/rates.dart';

part 'settings_event.dart';
part 'settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  SettingsBloc() : super(SettingsInitial()) {
    Future<List<Rates>> getRatesFromDb() async {
      double goldSettings = prefs.containsKey("GoldSettings")
          ? double.parse(prefs.get("GoldSettings").toString())
          : 0;
      double silverSettings = prefs.containsKey("SilverSettings")
          ? double.parse(prefs.get("SilverSettings").toString())
          : 0;
      var ratesFromDb = await db.rawQuery("SELECT * FROM RATES");

      return ratesFromDb
          .map(
            (e) => Rates(
              serverId: e['serverId'].toString(),
              nepaliDate: e['nep_date'].toString(),
              gold: (double.parse(e['gold'].toString()) + goldSettings)
                  .toString(),
              silver: (double.parse(e['silver'].toString()) + silverSettings)
                  .toString(),
              englishDate: e['eng_date'].toString(),
              goldDiff: e['gold_diff'].toString(),
              silverDiff: e['silver_diff'].toString(),
            ),
          )
          .toList()
          .reversed
          .toList();
    }

    on<SettingsEvent>((event, emit) {});

    on<OnShopSettingsLogoChangedEvent>((event, emit) {
      emit(OnShopSettingsLogoChangedState());
    });

    on<OnRatesSettingChangedEvent>((event, emit) async {
      List<Rates> rates = await getRatesFromDb();
      emit(OnRatesSettingChangedState(rates: rates));
    });
    // on<SettingsOnLoadingEvent>((event, emit) {
    //   print("bloc fuctiom ${event.isLoading}");
    //   emit(SettingsOnLoadingState(
    //     isLoading: event.isLoading,
    //   ));
    // });
  }
}
