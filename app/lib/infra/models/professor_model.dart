import 'dart:convert';

import '../../domain/entities/professor.dart';

class ProfessorModel extends Professor {
  ProfessorModel({
    required super.id,
    required super.nome,
    required super.turmasIds,
    required super.isAtivo,
  });

  factory ProfessorModel.fromEntity(Professor entity) => ProfessorModel(
    id: entity.id,
    nome: entity.nome,
    turmasIds: List<String>.from(entity.turmasIds),
    isAtivo: entity.isAtivo,
  );

  Professor toEntity() => Professor(
    id: id,
    nome: nome,
    turmasIds: List<String>.from(turmasIds),
    isAtivo: isAtivo,
  );

  factory ProfessorModel.fromMap(Map<String, dynamic> map) => ProfessorModel(
    id: map['id'] as String,
    nome: map['nome'] as String,
    turmasIds: List<String>.from(map['turmasIds'] as List<dynamic>),
    isAtivo: map['isAtivo'] as bool,
  );

  factory ProfessorModel.fromJson(String source) => ProfessorModel.fromMap(
    Map<String, dynamic>.from(jsonDecode(source) as Map<String, dynamic>),
  );

  @override
  String toJson() => jsonEncode(toMap());
}
