import 'package:app/ui/auth/page/auth_page.dart';
import 'package:go_router/go_router.dart';

abstract final class AuthRoute {
  static const String name = 'auth';
  static const String path = '/auth';

  static GoRoute get route => GoRoute(
    path: path,
    name: name,
    builder: (context, state) => const AuthPage(),
  );
}
