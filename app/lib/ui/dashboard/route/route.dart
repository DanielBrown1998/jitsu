import 'package:app/ui/dashboard/page/dashboard_page.dart';
import 'package:go_router/go_router.dart';

abstract final class DashboardRoute {
  static const String name = 'dashboard';
  static const String path = '/dashboard';

  static GoRoute get route => GoRoute(
    path: path,
    name: name,
    builder: (context, state) => const DashboardPage(),
  );
}
