import 'package:flutter_riverpod/flutter_riverpod.dart';

class DemoModeNotifier extends StateNotifier<bool> {
  DemoModeNotifier() : super(false);

  void toggleDemoMode() {
    state = !state;
  }

  void setDemoMode(bool value) {
    state = value;
  }
}

final demoModeProvider = StateNotifierProvider<DemoModeNotifier, bool>((ref) {
  return DemoModeNotifier();
});
