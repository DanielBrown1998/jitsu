import 'package:app/ui/graduation_success/page/graduation_success_page.dart';
import 'package:go_router/go_router.dart';

abstract final class GraduationSuccessRoute {
  static const String name = 'graduation_success';
  static const String path = '/graduation/success';

  static GoRoute get route => GoRoute(
    path: path,
    name: name,
    builder: (context, state) => const GraduationSuccessPage(),
  );
}
