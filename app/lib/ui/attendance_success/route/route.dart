import 'package:app/ui/attendance_success/page/attendance_success_page.dart';
import 'package:go_router/go_router.dart';

abstract final class AttendanceSuccessRoute {
  static const String name = 'attendance_success';
  static const String path = '/attendance/success';

  static GoRoute get route => GoRoute(
    path: path,
    name: name,
    builder: (context, state) => const AttendanceSuccessPage(),
  );
}
