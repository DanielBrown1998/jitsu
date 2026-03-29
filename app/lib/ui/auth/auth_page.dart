import 'package:flutter/material.dart';

class AuthPage extends StatelessWidget {
  final Widget child;

  const AuthPage({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: child);
  }
}
