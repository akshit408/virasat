import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/localization/app_localizations.dart';
import 'core/localization/app_localizations_delegate.dart';
import 'core/localization/locale_provider.dart';
import 'core/theme/app_theme.dart';
import 'routes/app_router.dart';

import 'core/config/env_config.dart';
import 'services/supabase_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  const backendUrl = EnvConfig.backendBaseUrl;
  const geminiKey = EnvConfig.geminiApiKey;
  final maskedKey = geminiKey.length > 8
      ? '${geminiKey.substring(0, 4)}...${geminiKey.substring(geminiKey.length - 4)}'
      : (geminiKey.isNotEmpty ? '***' : 'NOT SET');

  if (backendUrl.contains('localhost') || backendUrl.contains('127.0.0.1')) {
    debugPrint('====================================================');
    debugPrint('[ERROR] API BASE URL MUST USE RECHABLE PC LAN IP FOR PHYSICAL ANDROID PHONE!');
    debugPrint('[ERROR] Current Base URL: $backendUrl');
    debugPrint('====================================================');
  }
  debugPrint('API BASE URL = $backendUrl (Gemini API Key: $maskedKey)');
  debugPrint('====================================================');

  await SupabaseService.initialize();
  runApp(
    const ProviderScope(
      child: VirasatApp(),
    ),
  );
}

class VirasatApp extends ConsumerWidget {
  const VirasatApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(localeNotifierProvider);

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'VIRASAT — Crafted by India',
      theme: AppTheme.lightTheme,
      locale: locale,
      supportedLocales: AppLocalizations.supportedLanguages
          .map((lang) => Locale(lang['code']!))
          .toList(),
      localizationsDelegates: const [
        AppLocalizationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      routerConfig: appRouter,
    );
  }
}
