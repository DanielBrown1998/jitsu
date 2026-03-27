import 'package:app/ui/graduation_promote/page/graduation_promote_page.dart';
import 'package:go_router/go_router.dart';

abstract final class GraduationPromoteRoute {
  static const String name = 'graduation_promote';
  static const String path = '/graduation/promote';

  static GoRoute get route => GoRoute(
    path: path,
    name: name,
    builder: (context, state) => const GraduationPromotePage(),
  );
}
