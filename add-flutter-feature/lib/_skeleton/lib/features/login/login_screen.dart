import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:{{ appPackageName }}/utils/extensions.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        child: Text(context.l10n.login),
        onPressed: () => context.go('/'),
      ),
    );
  }
}
