import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:{{ appPackageName }}/utils/extensions.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        child: Text(context.l10n.home),
        onPressed: () => context.go('/login'),
      ),
    );
  }
}
