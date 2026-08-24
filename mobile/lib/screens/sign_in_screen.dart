import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../auth/auth_providers.dart';

class SignInScreen extends HookConsumerWidget {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isSigningIn = useState(false);
    final errorMessage = useState<String?>(null);

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
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Sign in'),
            const SizedBox(height: 16),
            if (errorMessage.value != null) ...[
              Text(errorMessage.value!, style: const TextStyle(color: Colors.red)),
              const SizedBox(height: 16),
            ],
            ElevatedButton(
              onPressed: isSigningIn.value ? null : signIn,
              child: isSigningIn.value
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Sign in with Google'),
            ),
          ],
        ),
      ),
    );
  }
}
