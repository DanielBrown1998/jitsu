// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';

class AulaRealizada extends Equatable {
  final String id;
  final String turmaId;
  final DateTime dataHora;
  final String professorResponsavel;
  final List<String> alunosPresentes;

  AulaRealizada({
    required this.id,
    required this.turmaId,
    required this.dataHora,
    required this.professorResponsavel,
    required this.alunosPresentes,
  });

  AulaRealizada copyWith({
    String? id,
    String? turmaId,
    DateTime? dataHora,
    String? professorResponsavel,
    List<String>? alunosPresentes,
  }) {
    return AulaRealizada(
      id: id ?? this.id,
      turmaId: turmaId ?? this.turmaId,
      dataHora: dataHora ?? this.dataHora,
      professorResponsavel: professorResponsavel ?? this.professorResponsavel,
      alunosPresentes: alunosPresentes ?? this.alunosPresentes,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'turmaId': turmaId,
      'dataHora': dataHora.millisecondsSinceEpoch,
      'professorResponsavel': professorResponsavel,
      'alunosPresentes': alunosPresentes,
    };
  }

  factory AulaRealizada.fromMap(Map<String, dynamic> map) {
    return AulaRealizada(
      id: map['id'] as String,
      turmaId: map['turmaId'] as String,
      dataHora: DateTime.fromMillisecondsSinceEpoch(map['dataHora'] as int),
      professorResponsavel: map['professorResponsavel'] as String,
      alunosPresentes: List<String>.from(
        (map['alunosPresentes'] as List<String>),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory AulaRealizada.fromJson(String source) =>
      AulaRealizada.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'AulaRealizada(id: $id, turmaId: $turmaId, dataHora: $dataHora, professorResponsavel: $professorResponsavel, alunosPresentes: $alunosPresentes)';
  }

  AulaRealizada registrarPresenca(String alunoId) {
    final presentesAtualizados = List<String>.from(alunosPresentes);
    if (!presentesAtualizados.contains(alunoId)) {
      presentesAtualizados.add(alunoId);
    }
    return copyWith(alunosPresentes: presentesAtualizados);
  }

  @override
  List<Object?> get props => [
    id,
    turmaId,
    dataHora,
    professorResponsavel,
    alunosPresentes,
  ];
}
