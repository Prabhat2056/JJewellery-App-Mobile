part of 'settings_bloc.dart';

@immutable
sealed class SettingsState {}

final class SettingsInitial extends SettingsState {}

class OnShopSettingsLogoChangedState extends SettingsState {}

class OnRatesSettingChangedState extends SettingsState {
  final List<Rates> rates;
  OnRatesSettingChangedState({required this.rates});
}

// class SettingsOnLoadingState extends SettingsState {
//   final bool isLoading;
//   SettingsOnLoadingState({required this.isLoading});
// }
