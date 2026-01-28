// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:collection/collection.dart';

import 'status_graduacao.dart';

class Aluno {
  final String id;
  final String nome;
  final String email;
  final String telefone;
  final String dataNascimento;
  final List<String> turmasIds;
  final StatusGraduacao statusGraduacao;
  final bool isAtivo;

  Aluno({
    required this.id,
    required this.nome,
    required this.email,
    required this.telefone,
    required this.dataNascimento,
    required this.turmasIds,
    required this.statusGraduacao,
    this.isAtivo = true,
  });

  Aluno copyWith({
    String? id,
    String? nome,
    String? email,
    String? telefone,
    String? dataNascimento,
    List<String>? turmasIds,
    StatusGraduacao? statusGraduacao,
    bool? isAtivo,
  }) {
    return Aluno(
      id: id ?? this.id,
      nome: nome ?? this.nome,
      email: email ?? this.email,
      telefone: telefone ?? this.telefone,
      dataNascimento: dataNascimento ?? this.dataNascimento,
      turmasIds: turmasIds ?? this.turmasIds,
      statusGraduacao: statusGraduacao ?? this.statusGraduacao,
      isAtivo: isAtivo ?? this.isAtivo,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'nome': nome,
      'email': email,
      'telefone': telefone,
      'dataNascimento': dataNascimento,
      'turmasIds': turmasIds,
      'statusGraduacao': statusGraduacao.toMap(),
      'isAtivo': isAtivo,
    };
  }

  factory Aluno.fromMap(Map<String, dynamic> map) {
    return Aluno(
      id: map['id'] as String,
      nome: map['nome'] as String,
      email: map['email'] as String,
      telefone: map['telefone'] as String,
      dataNascimento: map['dataNascimento'] as String,
      turmasIds: List<String>.from((map['turmasIds'] as List<String>)),
      statusGraduacao: StatusGraduacao.fromMap(
        map['statusGraduacao'] as Map<String, dynamic>,
      ),
      isAtivo: map['isAtivo'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory Aluno.fromJson(String source) =>
      Aluno.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Aluno(id: $id, nome: $nome, email: $email, telefone: $telefone, dataNascimento: $dataNascimento, turmasIds: $turmasIds, statusGraduacao: $statusGraduacao, isAtivo: $isAtivo)';
  }

  @override
  bool operator ==(covariant Aluno other) {
    if (identical(this, other)) return true;
    final listEquals = const DeepCollectionEquality().equals;

    return other.id == id &&
        other.nome == nome &&
        other.email == email &&
        other.telefone == telefone &&
        other.dataNascimento == dataNascimento &&
        listEquals(other.turmasIds, turmasIds) &&
        other.statusGraduacao == statusGraduacao &&
        other.isAtivo == isAtivo;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        nome.hashCode ^
        email.hashCode ^
        telefone.hashCode ^
        dataNascimento.hashCode ^
        turmasIds.hashCode ^
        statusGraduacao.hashCode ^
        isAtivo.hashCode;
  }
}
