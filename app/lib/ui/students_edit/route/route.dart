import 'package:app/ui/students_edit/page/students_edit_page.dart';
import 'package:go_router/go_router.dart';

abstract final class StudentsEditRoute {
  static const String name = 'students_edit';
  static const String path = '/students/edit';

  static GoRoute get route => GoRoute(
    path: path,
    name: name,
    builder: (context, state) => const StudentsEditPage(),
  );
}
