import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app_localizations.dart';

const String _prefsLanguageKey = 'virasat_selected_language';

class LocaleNotifier extends StateNotifier<Locale> {
  LocaleNotifier() : super(const Locale('en')) {
    _loadSavedLocale();
  }

  Future<void> _loadSavedLocale() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedCode = prefs.getString(_prefsLanguageKey) ?? 'en';
      state = Locale(savedCode);
    } catch (_) {
      state = const Locale('en');
    }
  }

  Future<void> setLanguageCode(String code) async {
    state = Locale(code);
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_prefsLanguageKey, code);
    } catch (_) {}
  }

  Future<void> setLanguageByName(String languageName) async {
    final match = AppLocalizations.supportedLanguages.firstWhere(
      (lang) => lang['name']!.toLowerCase() == languageName.toLowerCase() ||
          lang['native']!.toLowerCase() == languageName.toLowerCase(),
      orElse: () => {'code': 'en'},
    );
    await setLanguageCode(match['code']!);
  }

  String get currentLanguageName {
    final match = AppLocalizations.supportedLanguages.firstWhere(
      (lang) => lang['code'] == state.languageCode,
      orElse: () => {'name': 'English'},
    );
    return match['name']!;
  }
}

final localeNotifierProvider = StateNotifierProvider<LocaleNotifier, Locale>((ref) {
  return LocaleNotifier();
});

final currentLanguageNameProvider = Provider<String>((ref) {
  final locale = ref.watch(localeNotifierProvider);
  final match = AppLocalizations.supportedLanguages.firstWhere(
    (lang) => lang['code'] == locale.languageCode,
    orElse: () => {'name': 'English'},
  );
  return match['name']!;
});
