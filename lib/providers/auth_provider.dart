import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide AuthState;
import '../models/user_model.dart';
import '../services/auth_service.dart';

final authServiceProvider = Provider<AuthService>((ref) => AuthService());

class AuthState {
  final UserModel user;
  final bool isLoading;
  final String? errorMessage;
  final bool isInitialized;

  const AuthState({
    required this.user,
    this.isLoading = false,
    this.errorMessage,
    this.isInitialized = false,
  });

  bool get isAuthenticated => user.isAuthenticated;
  bool get isGuest => user.isGuest;

  AuthState copyWith({
    UserModel? user,
    bool? isLoading,
    String? errorMessage,
    bool? isInitialized,
  }) {
    return AuthState(
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      isInitialized: isInitialized ?? this.isInitialized,
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthService _authService;
  StreamSubscription<dynamic>? _authSub;

  AuthNotifier(this._authService)
      : super(AuthState(user: _authService.currentUser, isInitialized: false)) {
    _listenToAuthChanges();
    initSession();
  }

  void _listenToAuthChanges() {
    try {
      _authSub = Supabase.instance.client.auth.onAuthStateChange.listen((data) async {
        final event = data.event;
        if (event == AuthChangeEvent.signedIn ||
            event == AuthChangeEvent.tokenRefreshed ||
            event == AuthChangeEvent.initialSession ||
            event == AuthChangeEvent.userUpdated) {
          final user = await _authService.loadSavedSession();
          if (mounted) {
            state = state.copyWith(user: user, isInitialized: true);
          }
        } else if (event == AuthChangeEvent.signedOut) {
          if (mounted) {
            state = state.copyWith(
              user: const UserModel(
                id: '',
                name: '',
                phone: '',
                email: '',
                role: UserRole.buyer,
                isGuest: false,
              ),
              isInitialized: true,
            );
          }
        }
      });
    } catch (_) {}
  }

  @override
  void dispose() {
    _authSub?.cancel();
    super.dispose();
  }

  /// Restores persistent user session on startup
  Future<void> initSession() async {
    state = state.copyWith(isLoading: true);
    final user = await _authService.loadSavedSession();
    state = state.copyWith(user: user, isLoading: false, isInitialized: true);
  }

  Future<bool> login(String emailOrPhone, String password) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final user = await _authService.login(emailOrPhone: emailOrPhone, password: password);
      state = state.copyWith(user: user, isLoading: false);
      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString().replaceAll('Exception: ', ''));
      return false;
    }
  }

  Future<bool> signInWithGoogle() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final user = await _authService.signInWithGoogle();
      state = state.copyWith(user: user, isLoading: false);
      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString().replaceAll('Exception: ', ''));
      return false;
    }
  }

  Future<bool> sendPhoneOtp(String phone) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final res = await _authService.sendPhoneOtp(phone);
      state = state.copyWith(isLoading: false);
      return res;
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString().replaceAll('Exception: ', ''));
      return false;
    }
  }

  Future<bool> verifyPhoneOtp({required String phone, required String token, UserRole role = UserRole.buyer}) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final user = await _authService.verifyPhoneOtp(phone: phone, token: token, role: role);
      state = state.copyWith(user: user, isLoading: false);
      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString().replaceAll('Exception: ', ''));
      return false;
    }
  }

  Future<bool> register({
    required String name,
    required String email,
    required String password,
    required UserRole role,
    String? phone,
    String? stateName,
    String? district,
    String? craftCategory,
  }) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final user = await _authService.registerUser(
        name: name,
        email: email,
        password: password,
        role: role,
        phone: phone,
        state: stateName,
        district: district,
        craftCategory: craftCategory,
      );
      state = state.copyWith(user: user, isLoading: false);
      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString().replaceAll('Exception: ', ''));
      return false;
    }
  }

  Future<bool> forgotPassword(String email) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final res = await _authService.sendPasswordResetEmail(email);
      state = state.copyWith(isLoading: false);
      return res;
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString().replaceAll('Exception: ', ''));
      return false;
    }
  }

  Future<void> continueAsGuest() async {
    state = state.copyWith(isLoading: true);
    final guestUser = await _authService.continueAsGuest();
    state = state.copyWith(user: guestUser, isLoading: false);
  }

  Future<void> switchRole(UserRole newRole) async {
    await _authService.switchRole(newRole);
    state = state.copyWith(user: _authService.currentUser);
  }

  Future<bool> updateProfile({
    String? name,
    String? phone,
    String? email,
    String? stateName,
    String? district,
    String? preferredLanguage,
    String? bio,
    String? avatarUrl,
  }) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final updatedUser = await _authService.updateProfile(
        name: name,
        phone: phone,
        email: email,
        state: stateName,
        district: district,
        preferredLanguage: preferredLanguage,
        bio: bio,
        avatarUrl: avatarUrl,
      );
      state = state.copyWith(user: updatedUser, isLoading: false);
      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString().replaceAll('Exception: ', ''));
      return false;
    }
  }

  Future<void> logout() async {
    state = state.copyWith(isLoading: true);
    await _authService.logout();
    state = state.copyWith(user: _authService.currentUser, isLoading: false);
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(ref.watch(authServiceProvider));
});

final selectedLanguageProvider = StateProvider<String>((ref) => 'English');
