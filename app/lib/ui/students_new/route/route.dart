import 'package:app/ui/students_new/page/students_new_page.dart';
import 'package:go_router/go_router.dart';

abstract final class StudentsNewRoute {
  static const String name = 'students_new';
  static const String path = '/students/new';

  static GoRoute get route => GoRoute(
    path: path,
    name: name,
    builder: (context, state) => const StudentsNewPage(),
  );
}
