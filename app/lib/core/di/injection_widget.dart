import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class InjectionWidget extends StatelessWidget {
  final Widget child;
  const InjectionWidget({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Provider(create: (context) {}, child: child);
  }
}
