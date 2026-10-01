import 'package:flutter_riverpod/flutter_riverpod.dart';

final bottomNavIndexProvider = StateProvider<int>((ref) => 0);

class OnboardingNotifier extends StateNotifier<bool> {
  OnboardingNotifier() : super(false);

  void completeOnboarding() {
    state = true;
  }
}

final onboardingCompletedProvider = StateNotifierProvider<OnboardingNotifier, bool>((ref) {
  return OnboardingNotifier();
});
