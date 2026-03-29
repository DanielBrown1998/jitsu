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

class Jitsu extends StatefulWidget {
  const Jitsu({super.key});

  @override
  State<Jitsu> createState() => _JitsuState();
}

class _JitsuState extends State<Jitsu> with WidgetsBindingObserver {
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.resumed:
        break;
      case AppLifecycleState.inactive:
        break;
      case AppLifecycleState.paused:
        break;
      case AppLifecycleState.detached:
        break;
      case AppLifecycleState.hidden:
        break;
    }
  }

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

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
