import 'package:app/ui/attendance_register/page/attendance_register_page.dart';
import 'package:go_router/go_router.dart';

abstract final class AttendanceRegisterRoute {
  static const String name = 'attendance_register';
  static const String path = '/attendance/register';

  static GoRoute get route => GoRoute(
    path: path,
    name: name,
    builder: (context, state) => const AttendanceRegisterPage(),
  );
}
