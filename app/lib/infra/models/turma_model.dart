import 'dart:convert';

import 'package:app/domain/entities/entities.dart';

import '../../domain/entities/turma.dart';

class TurmaModel extends Turma {
  TurmaModel({
    required super.id,
    required super.nome,
    required super.professorId,
    required super.horarioPadrao,
    required super.tipoDeTurma,
    required super.diasSemana,
  });

  factory TurmaModel.fromEntity(Turma entity) => TurmaModel(
    id: entity.id,
    nome: entity.nome,
    professorId: entity.professorId,
    horarioPadrao: entity.horarioPadrao,
    tipoDeTurma: entity.tipoDeTurma,
    diasSemana: entity.diasSemana,
  );

  Turma toEntity() => Turma(
    id: id,
    nome: nome,
    professorId: professorId,
    horarioPadrao: horarioPadrao,
    tipoDeTurma: tipoDeTurma,
    diasSemana: diasSemana,
  );

  static List<int> _parseDiasSemana(Map<String, dynamic> map) {
    final raw = map['diasSemana'];
    if (raw is List) {
      final parsed = raw
          .map((value) => value is int ? value : int.tryParse(value.toString()))
          .whereType<int>()
          .toList();

      if (parsed.isNotEmpty) {
        return parsed;
      }
    }

    return Turma.defaultDiasSemana;
  }

  factory TurmaModel.fromMap(Map<String, dynamic> map) => TurmaModel(
    id: map['id'] as String,
    nome: map['nome'] as String,
    professorId: map['professorId'] as String,
    horarioPadrao: map['horarioPadrao'] as String,
    tipoDeTurma: TipoDeTurma.fromDisplayName(map['tipoDeTurma'] as String),
    diasSemana: _parseDiasSemana(map),
  );

  factory TurmaModel.fromJson(String source) => TurmaModel.fromMap(
    Map<String, dynamic>.from(jsonDecode(source) as Map<String, dynamic>),
  );

  @override
  String toJson() => jsonEncode(toMap());
}
