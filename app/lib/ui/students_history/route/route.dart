import 'package:app/ui/students_history/page/students_history_page.dart';
import 'package:go_router/go_router.dart';

abstract final class StudentsHistoryRoute {
  static const String name = 'students_history';
  static const String path = '/students/history';

  static GoRoute get route => GoRoute(
    path: path,
    name: name,
    builder: (context, state) => const StudentsHistoryPage(),
  );
}
