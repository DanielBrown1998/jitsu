import 'package:go_router/go_router.dart';
import '../di/injection.dart';
import '../../ui/route.dart';
import '../../ui/auth/logic/state.dart';
import '../../ui/auth/logic/vm.dart';

abstract final class AppRouter {
  static final router = GoRouter(
    refreshListenable: getIt<AuthVm>(),
    redirect: (context, state) {
      final authVm = getIt<AuthVm>();
      final isLoggedOut = !authVm.state.isLoggedIn;
      final location = state.matchedLocation;
      final isOnAuthArea = location.startsWith('/auth');

      if (isLoggedOut && !isOnAuthArea) {
        return Routes.splash.path;
      }

      if (!isLoggedOut && isOnAuthArea) {
        return switch (authVm.state.role) {
          UserRole.student => StudentHomeRoute.path,
          UserRole.admin || UserRole.professor => AdminHomeRoute.path,
        };
      }

      return null;
    },
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
