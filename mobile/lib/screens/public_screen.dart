import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class PublicScreen extends StatelessWidget {
  const PublicScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Public experience'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.go('/sign-in'),
              child: const Text('Sign in'),
            ),
          ],
        ),
      ),
    );
  }
}
