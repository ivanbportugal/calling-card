import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../auth/auth_providers.dart';
import '../theme/app_theme.dart';
import '../theme/theme_extensions.dart';

class SignInScreen extends HookConsumerWidget {
  const SignInScreen({super.key});

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
      } catch (error) {
        errorMessage.value = 'Sign in failed. Please try again.';
      } finally {
        isSigningIn.value = false;
      }
    }

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Welcome back',
                style: context.textTheme.headlineMedium?.copyWith(
                  color: colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Sign in to see who has friends over.',
                textAlign: TextAlign.center,
                style: context.textTheme.bodyLarge?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 32),
              if (errorMessage.value != null) ...[
                Text(
                  errorMessage.value!,
                  style: TextStyle(color: colorScheme.tertiary),
                ),
                const SizedBox(height: 16),
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
          ),
        ),
      ),
    );
  }
}
