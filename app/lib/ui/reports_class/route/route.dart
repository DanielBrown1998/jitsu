import 'package:app/ui/reports_class/page/reports_class_page.dart';
import 'package:go_router/go_router.dart';

abstract final class ReportsClassRoute {
  static const String name = 'reports_class';
  static const String path = '/reports/class';

  static GoRoute get route => GoRoute(
    path: path,
    name: name,
    builder: (context, state) => const ReportsClassPage(),
  );
}
