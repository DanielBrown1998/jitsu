// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:equatable/equatable.dart';

import 'entities.dart';

class Turma extends Equatable {
  static const List<int> defaultDiasSemana = [1, 2, 3, 4, 5, 6, 7];

  final String id;
  final String nome;
  final String professorId;
  final String horarioPadrao;
  final TipoDeTurma tipoDeTurma; // Presencial, Online, Híbrida
  final List<int> diasSemana; // 1=segunda ... 7=domingo

  Turma({
    required this.id,
    required this.nome,
    required this.professorId,
    required this.horarioPadrao,
    required this.tipoDeTurma,
    List<int>? diasSemana,
  }) : diasSemana = _normalizeDiasSemana(diasSemana);

  static List<int> _normalizeDiasSemana(List<int>? dias) {
    if (dias == null || dias.isEmpty) {
      return List.unmodifiable(defaultDiasSemana);
    }

    final normalized =
        dias.where((day) => day >= 1 && day <= 7).toSet().toList()..sort();

    if (normalized.isEmpty) {
      return List.unmodifiable(defaultDiasSemana);
    }

    return List.unmodifiable(normalized);
  }

  bool ocorreNoDia(int weekday) => diasSemana.contains(weekday);

  Turma copyWith({
    String? id,
    String? nome,
    String? professorId,
    String? horarioPadrao,
    TipoDeTurma? tipoDeTurma,
    List<int>? diasSemana,
  }) {
    return Turma(
      id: id ?? this.id,
      nome: nome ?? this.nome,
      professorId: professorId ?? this.professorId,
      horarioPadrao: horarioPadrao ?? this.horarioPadrao,
      tipoDeTurma: tipoDeTurma ?? this.tipoDeTurma,
      diasSemana: diasSemana ?? this.diasSemana,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'nome': nome,
      'professorId': professorId,
      'horarioPadrao': horarioPadrao,
      'tipoDeTurma': tipoDeTurma.toString(),
      'diasSemana': diasSemana,
    };
  }

  factory Turma.fromMap(Map<String, dynamic> map) {
    final rawDias = map['diasSemana'];
    final diasSemana = rawDias is List
        ? rawDias
              .map(
                (value) =>
                    value is int ? value : int.tryParse(value.toString()),
              )
              .whereType<int>()
              .toList()
        : null;

    return Turma(
      id: map['id'] as String,
      nome: map['nome'] as String,
      professorId: map['professorId'] as String,
      horarioPadrao: map['horarioPadrao'] as String,
      tipoDeTurma: TipoDeTurma.fromDisplayName(map['tipoDeTurma'] as String),
      diasSemana: diasSemana,
    );
  }

  String toJson() => json.encode(toMap());

  factory Turma.fromJson(String source) =>
      Turma.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Turma(id: $id, nome: $nome, professorId: $professorId, horarioPadrao: $horarioPadrao, tipoDeTurma: $tipoDeTurma, diasSemana: $diasSemana)';
  }

  @override
  List<Object?> get props => [
    id,
    nome,
    professorId,
    horarioPadrao,
    tipoDeTurma,
    diasSemana,
  ];
}
