import 'package:app/core/di/injection.dart';
import 'package:app/core/di/injection_widget.dart';
import 'package:flutter/material.dart';
import 'core/firebase/instance.dart';
import 'core/router/router.dart';
import 'core/theme/theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FirebaseInstance.initialize();
  await initDependencies();
  runApp(const Jitsu());
}

class Jitsu extends StatelessWidget {
  const Jitsu({super.key});

  @override
  Widget build(BuildContext context) {
    return InjectionWidget(
      child: MaterialApp.router(
        title: 'Jitsu',
        theme: AppTheme.lightTheme(),
        darkTheme: AppTheme.darkTheme(),
        themeMode: ThemeMode.light,
        routerConfig: AppRouter.router,
      ),
    );
  }
}
