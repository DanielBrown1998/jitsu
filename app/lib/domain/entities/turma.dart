// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'entities.dart';

class Turma {
  final String id;
  final String nome;
  final String professorId;
  final String horarioPadrao;
  final TipoDeTurma tipoDeTurma; // Presencial, Online, Híbrida

  Turma({
    required this.id,
    required this.nome,
    required this.professorId,
    required this.horarioPadrao,
    required this.tipoDeTurma,
  });

  Turma copyWith({
    String? id,
    String? nome,
    String? professorId,
    String? horarioPadrao,
    TipoDeTurma? tipoDeTurma,
  }) {
    return Turma(
      id: id ?? this.id,
      nome: nome ?? this.nome,
      professorId: professorId ?? this.professorId,
      horarioPadrao: horarioPadrao ?? this.horarioPadrao,
      tipoDeTurma: tipoDeTurma ?? this.tipoDeTurma,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'nome': nome,
      'professorId': professorId,
      'horarioPadrao': horarioPadrao,
      'tipoDeTurma': tipoDeTurma.toString(),
    };
  }

  factory Turma.fromMap(Map<String, dynamic> map) {
    return Turma(
      id: map['id'] as String,
      nome: map['nome'] as String,
      professorId: map['professorId'] as String,
      horarioPadrao: map['horarioPadrao'] as String,
      tipoDeTurma: TipoDeTurma.fromDisplayName(map['tipoDeTurma'] as String),
    );
  }

  String toJson() => json.encode(toMap());

  factory Turma.fromJson(String source) => Turma.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Turma(id: $id, nome: $nome, professorId: $professorId, horarioPadrao: $horarioPadrao, tipoDeTurma: $tipoDeTurma)';
  }

  @override
  bool operator ==(covariant Turma other) {
    if (identical(this, other)) return true;
  
    return 
      other.id == id &&
      other.nome == nome &&
      other.professorId == professorId &&
      other.horarioPadrao == horarioPadrao &&
      other.tipoDeTurma == tipoDeTurma;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      nome.hashCode ^
      professorId.hashCode ^
      horarioPadrao.hashCode ^
      tipoDeTurma.hashCode;
  }
}
