import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'locale_state.dart';

class LocaleCubit extends Cubit<LocaleState> {
  LocaleCubit() : super(const LocaleState(Locale('en'))) {
    _loadLocale();
  }

  Future<void> _loadLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final languageCode = prefs.getString('languageCode') ?? 'en';
    emit(LocaleState(Locale(languageCode)));
  }

  Future<void> changeLocale(Locale locale) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('languageCode', locale.languageCode);
    emit(LocaleState(locale));
  }

  // Language codes: 0=en, 1=ar, 2=fr
  Future<void> changeLocaleByCode(int code) async {
    final locales = [const Locale('en'), const Locale('ar'), const Locale('fr')];
    if (code >= 0 && code < locales.length) {
      await changeLocale(locales[code]);
    }
  }

  int getCurrentLanguageCode() {
    final code = state.locale.languageCode;
    switch (code) {
      case 'ar':
        return 1;
      case 'fr':
        return 2;
      default:
        return 0; // en
    }
  }
}


