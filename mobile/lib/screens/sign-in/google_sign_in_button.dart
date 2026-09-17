import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../auth/auth_providers.dart';
import '../../theme/app_theme.dart';
import '../../theme/theme_extensions.dart';

class GoogleSignInButton extends HookConsumerWidget {
  const GoogleSignInButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isSigningIn = useState(false);
    final errorMessage = useState<String?>(null);
    final colorScheme = context.colorScheme;

    Future<void> signIn() async {
      isSigningIn.value = true;
      errorMessage.value = null;
      try {
        await ref.read(authRepositoryProvider).signInWithGoogle();
      } catch (_) {
        errorMessage.value = 'Google sign in failed. Please try again.';
      } finally {
        isSigningIn.value = false;
      }
    }

    return Column(
      children: [
        if (errorMessage.value != null) ...[
          Text(
            errorMessage.value!,
            style: TextStyle(color: colorScheme.tertiary),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
        ],
        SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton.icon(
            onPressed: isSigningIn.value ? null : signIn,
            style: ElevatedButton.styleFrom(
              backgroundColor: colorScheme.statusOpen,
              foregroundColor: colorScheme.onPrimary,
            ),
            icon: isSigningIn.value
                ? const SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
                : const Icon(Icons.login),
            label: Text(
              isSigningIn.value ? 'Signing in…' : 'Sign in with Google',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),
        ),
      ],
    );
  }
}