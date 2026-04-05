import 'package:app/domain/entities/turma.dart';

class DashboardClassItem {
  final String time;
  final String name;
  final String instructorAndType;
  final String studentsLabel;

  const DashboardClassItem({
    required this.time,
    required this.name,
    required this.instructorAndType,
    required this.studentsLabel,
  });
}

class DashboardState {
  bool isLoading;
  String? error;
  bool hasLoaded;
  List<Turma> turmas;
  List<DashboardClassItem> classes;
  int totalTurmasAtivas;
  int aulasHoje;

  DashboardState({
    required this.isLoading,
    required this.error,
    required this.hasLoaded,
    required this.turmas,
    required this.classes,
    required this.totalTurmasAtivas,
    required this.aulasHoje,
  });

  DashboardState emit({
    bool? isLoading,
    String? error,
    bool? hasLoaded,
    List<Turma>? turmas,
    List<DashboardClassItem>? classes,
    int? totalTurmasAtivas,
    int? aulasHoje,
    bool clearError = false,
  }) {
    this.isLoading = isLoading ?? this.isLoading;
    this.error = clearError ? null : error ?? this.error;
    this.hasLoaded = hasLoaded ?? this.hasLoaded;
    this.turmas = turmas ?? this.turmas;
    this.classes = classes ?? this.classes;
    this.totalTurmasAtivas = totalTurmasAtivas ?? this.totalTurmasAtivas;
    this.aulasHoje = aulasHoje ?? this.aulasHoje;
    return this;
  }
}
