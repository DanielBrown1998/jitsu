/// Barrel file para exportar todos os modelos
// ignore_for_file: unused_element

library;

export 'status_graduacao.dart';
export 'aluno.dart';
export 'turma.dart';
export 'aula_realizada.dart';
export 'historico_presenca.dart';
export 'professor.dart';

enum Entities {
  aluno,
  // ignore: constant_identifier_names
  aula_realizada,
  // ignore: constant_identifier_names
  historico_presenca,
  // ignore: constant_identifier_names
  status_graduacao,
  turma;

  String getDisplayName() {
    return switch (this) {
      Entities.aluno => 'Aluno',
      Entities.aula_realizada => 'AulaRealizada',
      Entities.historico_presenca => 'HistoricoPresenca',
      Entities.status_graduacao => 'StatusGraduacao',
      Entities.turma => 'Turma',
    };
  }

  static Entities fromDisplayName(String name) {
    return Entities.values.firstWhere(
      (e) => e.getDisplayName() == name,
      orElse: () => throw ArgumentError('No entity found for name: $name'),
    );
  }
}

enum TipoDeTurma {
  adulto,
  kids;

  String getDisplayName(TipoDeTurma tipo) {
    return switch (tipo) {
      TipoDeTurma.adulto => 'Adulto',
      TipoDeTurma.kids => 'Kids',
    };
  }

  static TipoDeTurma fromDisplayName(String name) {
    return TipoDeTurma.values.firstWhere(
      (e) => e.getDisplayName(e) == name,
      orElse: () => throw ArgumentError('No TipoDeTurma found for name: $name'),
    );
  }
}
