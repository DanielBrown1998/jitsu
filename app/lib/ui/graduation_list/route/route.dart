import 'package:app/ui/graduation_list/page/graduation_list_page.dart';
import 'package:go_router/go_router.dart';

abstract final class GraduationListRoute {
  static const String name = 'graduation_list';
  static const String path = '/graduation/list';

  static GoRoute get route => GoRoute(
    path: path,
    name: name,
    builder: (context, state) => const GraduationListPage(),
  );
}
