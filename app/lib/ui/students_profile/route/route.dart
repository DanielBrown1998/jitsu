import 'package:app/ui/students_profile/page/students_profile_page.dart';
import 'package:go_router/go_router.dart';

abstract final class StudentsProfileRoute {
  static const String name = 'students_profile';
  static const String path = '/students/profile';

  static GoRoute get route => GoRoute(
    path: path,
    name: name,
    builder: (context, state) => const StudentsProfilePage(),
  );
}
