import 'package:app/core/di/injection.dart';
import 'package:app/ui/auth/logic/vm.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class InjectionWidget extends StatelessWidget {
  final Widget child;
  const InjectionWidget({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthVm>.value(value: getIt.get<AuthVm>()),
      ],
      child: child,
    );
  }
}
