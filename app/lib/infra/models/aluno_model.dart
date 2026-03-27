import 'dart:convert';

import '../../domain/entities/aluno.dart';
import 'status_graduacao_model.dart';

class AlunoModel extends Aluno {
  AlunoModel({
    required super.id,
    required super.nome,
    required super.email,
    required super.telefone,
    required super.dataNascimento,
    required super.turmasIds,
    required super.statusGraduacao,
    super.isAtivo = true,
  });

  factory AlunoModel.fromEntity(Aluno entity) {
    return AlunoModel(
      id: entity.id,
      nome: entity.nome,
      email: entity.email,
      telefone: entity.telefone,
      dataNascimento: entity.dataNascimento,
      turmasIds: List<String>.from(entity.turmasIds),
      statusGraduacao: StatusGraduacaoModel.fromEntity(entity.statusGraduacao),
      isAtivo: entity.isAtivo,
    );
  }

  Aluno toEntity() => Aluno(
    id: id,
    nome: nome,
    email: email,
    telefone: telefone,
    dataNascimento: dataNascimento,
    turmasIds: List<String>.from(turmasIds),
    statusGraduacao: statusGraduacao,
    isAtivo: isAtivo,
  );

  factory AlunoModel.fromMap(Map<String, dynamic> map) => AlunoModel(
    id: map['id'] as String,
    nome: map['nome'] as String,
    email: map['email'] as String,
    telefone: map['telefone'] as String,
    dataNascimento: map['dataNascimento'] as String,
    turmasIds: List<String>.from(map['turmasIds'] as List<dynamic>),
    statusGraduacao: StatusGraduacaoModel.fromMap(
      map['statusGraduacao'] as Map<String, dynamic>,
    ),
    isAtivo: map['isAtivo'] as bool,
  );

  @override
  Map<String, dynamic> toMap() {
    return {
      ...super.toMap(),
      'statusGraduacao': StatusGraduacaoModel.fromEntity(
        statusGraduacao,
      ).toMap(),
    };
  }

  factory AlunoModel.fromJson(String source) => AlunoModel.fromMap(
    Map<String, dynamic>.from(jsonDecode(source) as Map<String, dynamic>),
  );

  @override
  String toJson() => jsonEncode(toMap());
}
