import 'package:app/ui/attendance_select/page/attendance_select_page.dart';
import 'package:go_router/go_router.dart';

abstract final class AttendanceSelectRoute {
  static const String name = 'attendance_select';
  static const String path = '/attendance/select';

  static GoRoute get route => GoRoute(
    path: path,
    name: name,
    builder: (context, state) => const AttendanceSelectPage(),
  );
}
