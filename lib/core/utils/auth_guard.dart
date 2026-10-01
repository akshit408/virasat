import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/login_required_bottom_sheet.dart';

Future<bool> ensureAuthenticated(
  BuildContext context,
  WidgetRef ref, {
  String title = 'Sign In Required',
  String message = 'Please sign in to access this feature.',
}) async {
  final auth = ref.read(authProvider);
  if (auth.isAuthenticated && !auth.user.isGuest) {
    return true;
  }

  final result = await LoginRequiredBottomSheet.show(
    context,
    title: title,
    message: message,
  );
  return result ?? false;
}
