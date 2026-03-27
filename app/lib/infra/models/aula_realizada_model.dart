import 'dart:convert';

import '../../domain/entities/aula_realizada.dart';

class AulaRealizadaModel extends AulaRealizada {
  AulaRealizadaModel({
    required super.id,
    required super.turmaId,
    required super.dataHora,
    required super.professorResponsavel,
    required super.alunosPresentes,
  });

  factory AulaRealizadaModel.fromEntity(AulaRealizada entity) =>
      AulaRealizadaModel(
        id: entity.id,
        turmaId: entity.turmaId,
        dataHora: entity.dataHora,
        professorResponsavel: entity.professorResponsavel,
        alunosPresentes: List<String>.from(entity.alunosPresentes),
      );

  AulaRealizada toEntity() => AulaRealizada(
    id: id,
    turmaId: turmaId,
    dataHora: dataHora,
    professorResponsavel: professorResponsavel,
    alunosPresentes: List<String>.from(alunosPresentes),
  );

  factory AulaRealizadaModel.fromMap(Map<String, dynamic> map) =>
      AulaRealizadaModel(
        id: map['id'] as String,
        turmaId: map['turmaId'] as String,
        dataHora: DateTime.fromMillisecondsSinceEpoch(map['dataHora'] as int),
        professorResponsavel: map['professorResponsavel'] as String,
        alunosPresentes: List<String>.from(
          map['alunosPresentes'] as List<dynamic>,
        ),
      );

  factory AulaRealizadaModel.fromJson(String source) =>
      AulaRealizadaModel.fromMap(
        Map<String, dynamic>.from(jsonDecode(source) as Map<String, dynamic>),
      );

  @override
  String toJson() => jsonEncode(toMap());
}
