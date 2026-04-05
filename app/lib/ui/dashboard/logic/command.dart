import 'package:app/core/utils/command/command.dart';
import 'package:app/ui/auth/logic/state.dart';

class LoadDashboardInput extends CommandInput {
  final UserRole role;
  final String? professorId;
  final String? professorName;
  final List<String>? turmaIds;

  LoadDashboardInput({
    required this.role,
    this.professorId,
    this.professorName,
    this.turmaIds,
  });
}

class LoadDashboardCommand extends Command<LoadDashboardInput> {
  LoadDashboardCommand(super.action);
}
