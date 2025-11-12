part of 'settings_bloc.dart';

@immutable
sealed class SettingsEvent {}

class OnShopSettingsLogoChangedEvent extends SettingsEvent {}

class OnRatesSettingChangedEvent extends SettingsEvent {}

// class SettingsOnLoadingEvent extends SettingsEvent {
//   final bool isLoading;
//   SettingsOnLoadingEvent({required this.isLoading});
// }
