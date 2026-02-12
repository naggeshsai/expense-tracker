import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  static const _themeModeKey = 'theme_mode';
  static const _currencyKey = 'currency';
  static const _currencySymbolKey = 'currency_symbol';

  SettingsCubit() : super(const SettingsState()) {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final themeModeIndex = prefs.getInt(_themeModeKey) ?? ThemeMode.system.index;
    final currency = prefs.getString(_currencyKey) ?? 'USD';
    final currencySymbol = prefs.getString(_currencySymbolKey) ?? '\$';

    emit(SettingsState(
      themeMode: ThemeMode.values[themeModeIndex],
      currency: currency,
      currencySymbol: currencySymbol,
    ));
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_themeModeKey, mode.index);
    emit(state.copyWith(themeMode: mode));
  }

  Future<void> setCurrency(String currency, String symbol) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_currencyKey, currency);
    await prefs.setString(_currencySymbolKey, symbol);
    emit(state.copyWith(currency: currency, currencySymbol: symbol));
  }

  void toggleTheme() {
    final newMode = state.themeMode == ThemeMode.light
        ? ThemeMode.dark
        : ThemeMode.light;
    setThemeMode(newMode);
  }
}
