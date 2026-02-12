import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class SettingsState extends Equatable {
  final ThemeMode themeMode;
  final String currency;
  final String currencySymbol;

  const SettingsState({
    this.themeMode = ThemeMode.system,
    this.currency = 'USD',
    this.currencySymbol = '\$',
  });

  @override
  List<Object?> get props => [themeMode, currency, currencySymbol];

  SettingsState copyWith({
    ThemeMode? themeMode,
    String? currency,
    String? currencySymbol,
  }) {
    return SettingsState(
      themeMode: themeMode ?? this.themeMode,
      currency: currency ?? this.currency,
      currencySymbol: currencySymbol ?? this.currencySymbol,
    );
  }
}
