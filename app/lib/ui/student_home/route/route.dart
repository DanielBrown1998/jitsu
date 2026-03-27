import 'package:app/ui/student_home/page/student_home_page.dart';
import 'package:go_router/go_router.dart';

abstract final class StudentHomeRoute {
  static const String name = 'student_home';
  static const String path = '/student-home';

  static GoRoute get route => GoRoute(
    path: path,
    name: name,
    builder: (context, state) => const StudentHomePage(),
  );
}
