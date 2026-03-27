import 'package:app/ui/admin_home/page/admin_home_page.dart';
import 'package:go_router/go_router.dart';

abstract final class AdminHomeRoute {
  static const String name = 'admin_home';
  static const String path = '/admin-home';

  static GoRoute get route => GoRoute(
    path: path,
    name: name,
    builder: (context, state) => const AdminHomePage(),
  );
}
