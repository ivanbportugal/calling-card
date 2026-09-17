import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../auth/auth_providers.dart';
import '../../theme/theme_extensions.dart';

class EmailPasswordAuthForm extends HookConsumerWidget {
  const EmailPasswordAuthForm({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final emailController = useTextEditingController();
    final passwordController = useTextEditingController();
    final isSignUp = useState(false);
    final isLoading = useState(false);
    final errorMessage = useState<String?>(null);
    final colorScheme = context.colorScheme;

    Future<void> submit() async {
      final email = emailController.text.trim();
      final password = passwordController.text;

      if (email.isEmpty || password.isEmpty) {
        errorMessage.value = 'Please enter email and password.';
        return;
      }

      isLoading.value = true;
      errorMessage.value = null;

      try {
        final repo = ref.read(authRepositoryProvider);
        if (isSignUp.value) {
          await repo.createUserWithEmailAndPassword(
            email: email,
            password: password,
          );
        } else {
          await repo.signInWithEmailAndPassword(
            email: email,
            password: password,
          );
        }
      } on FirebaseAuthException catch (e) {
        errorMessage.value = _mapFirebaseError(e.code);
      } catch (_) {
        errorMessage.value = 'Something went wrong. Please try again.';
      } finally {
        isLoading.value = false;
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          controller: emailController,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
          decoration: const InputDecoration(
            labelText: 'Email',
            prefixIcon: Icon(Icons.email_outlined),
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: passwordController,
          obscureText: true,
          textInputAction: TextInputAction.done,
          onSubmitted: (_) => submit(),
          decoration: const InputDecoration(
            labelText: 'Password',
            prefixIcon: Icon(Icons.lock_outline),
          ),
        ),
        const SizedBox(height: 8),

        // Toggle Sign In ↔ Sign Up
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: isLoading.value
                ? null
                : () {
              isSignUp.value = !isSignUp.value;
              errorMessage.value = null;
            },
            child: Text(
              isSignUp.value
                  ? 'Already have an account? Sign in'
                  : 'Need an account? Sign up',
            ),
          ),
        ),

        if (errorMessage.value != null) ...[
          const SizedBox(height: 8),
          Text(
            errorMessage.value!,
            style: TextStyle(color: colorScheme.tertiary),
            textAlign: TextAlign.center,
          ),
        ],

        const SizedBox(height: 16),
        SizedBox(
          height: 56,
          child: ElevatedButton(
            onPressed: isLoading.value ? null : submit,
            child: isLoading.value
                ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
                : Text(
              isSignUp.value ? 'Create account' : 'Sign in',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }

  String _mapFirebaseError(String code) {
    switch (code) {
      case 'user-not-found':
      case 'wrong-password':
      case 'invalid-credential':
        return 'Invalid email or password.';
      case 'email-already-in-use':
        return 'This email is already registered.';
      case 'weak-password':
        return 'Password is too weak (min 6 characters).';
      case 'invalid-email':
        return 'Please enter a valid email address.';
      case 'too-many-requests':
        return 'Too many attempts. Try again later.';
      default:
        return 'Authentication failed. Please try again.';
    }
  }
}