import 'package:app/ui/reports/page/reports_page.dart';
import 'package:go_router/go_router.dart';

abstract final class ReportsRoute {
  static const String name = 'reports';
  static const String path = '/reports';

  static GoRoute get route => GoRoute(
    path: path,
    name: name,
    builder: (context, state) => const ReportsPage(),
  );
}
