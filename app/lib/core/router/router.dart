import 'package:go_router/go_router.dart';
import '../../ui/route.dart';

abstract final class AppRouter {
  static final router = GoRouter(
    initialLocation: AuthRoute.path,
    routes: [
      AuthRoute.route,
      AdminHomeRoute.route,
      StudentHomeRoute.route,
      StudentsListRoute.route,
      StudentsProfileRoute.route,
      StudentsNewRoute.route,
      StudentsEditRoute.route,
      StudentsHistoryRoute.route,
      AttendanceSelectRoute.route,
      AttendanceRegisterRoute.route,
      AttendanceSuccessRoute.route,
      GraduationListRoute.route,
      GraduationPromoteRoute.route,
      GraduationSuccessRoute.route,
      ReportsRoute.route,
      ReportsClassRoute.route,
    ],
  );
}
