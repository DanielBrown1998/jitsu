import 'package:app/ui/auth/auth_page.dart';
import 'package:app/ui/auth/pages/login.dart';
import 'package:app/ui/auth/pages/recovery_passoword.dart';
import 'package:app/ui/auth/pages/register.dart';
import 'package:app/ui/auth/pages/splash.dart';
import 'package:go_router/go_router.dart';

class Route {
  final String name;
  final String path;
  Route({required this.name, required this.path});
}

abstract class Routes {
  static final auth = Route(name: 'auth', path: '/auth');
  static final splash = Route(name: 'splash', path: '/auth/splash');
  static final login = Route(name: 'login', path: '/auth/login');
  static final recoverPassword = Route(
    name: 'recover_password',
    path: '/auth/recover-password',
  );
  static final register = Route(name: 'register', path: '/auth/register');
}

abstract final class AuthRoute {
  static const String name = 'auth';
  static const String path = '/auth';

  static ShellRoute get route => ShellRoute(
    builder: (context, state, child) => AuthPage(child: child),
    routes: [
      GoRoute(
        path: Routes.auth.path,
        name: Routes.auth.name,
        redirect: (context, state) => Routes.splash.path,
      ),
      GoRoute(
        path: Routes.splash.path,
        name: Routes.splash.name,
        builder: (context, state) => const SplashPage(),
      ),
      GoRoute(
        path: Routes.login.path,
        name: Routes.login.name,
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: Routes.recoverPassword.path,
        name: Routes.recoverPassword.name,
        builder: (context, state) => const RecoverPasswordPage(),
      ),
      GoRoute(
        path: Routes.register.path,
        name: Routes.register.name,
        builder: (context, state) => const RegisterPage(),
      ),
    ],
  );
}
