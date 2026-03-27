import 'package:app/ui/students_list/page/students_list_page.dart';
import 'package:go_router/go_router.dart';

abstract final class StudentsListRoute {
  static const String name = 'students_list';
  static const String path = '/students/list';

  static GoRoute get route => GoRoute(
    path: path,
    name: name,
    builder: (context, state) => const StudentsListPage(),
  );
}
