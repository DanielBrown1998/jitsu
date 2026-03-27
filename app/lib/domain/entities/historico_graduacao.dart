// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:equatable/equatable.dart';

class HistoricoGraduacao extends Equatable {
  final String id;
  final String faixaAnterior;
  final int grauAnterior;
  final String faixaNova;
  final int grauNovo;
  final DateTime data;
  final String? observacao;

  HistoricoGraduacao({
    required this.id,
    required this.faixaAnterior,
    required this.grauAnterior,
    required this.faixaNova,
    required this.grauNovo,
    required this.data,
    this.observacao,
  });

  HistoricoGraduacao copyWith({
    String? id,
    String? faixaAnterior,
    int? grauAnterior,
    String? faixaNova,
    int? grauNovo,
    DateTime? data,
    String? observacao,
  }) {
    return HistoricoGraduacao(
      id: id ?? this.id,
      faixaAnterior: faixaAnterior ?? this.faixaAnterior,
      grauAnterior: grauAnterior ?? this.grauAnterior,
      faixaNova: faixaNova ?? this.faixaNova,
      grauNovo: grauNovo ?? this.grauNovo,
      data: data ?? this.data,
      observacao: observacao ?? this.observacao,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'faixaAnterior': faixaAnterior,
      'grauAnterior': grauAnterior,
      'faixaNova': faixaNova,
      'grauNovo': grauNovo,
      'data': data.millisecondsSinceEpoch,
      'observacao': observacao,
    };
  }

  factory HistoricoGraduacao.fromMap(Map<String, dynamic> map) {
    return HistoricoGraduacao(
      id: map['id'] as String,
      faixaAnterior: map['faixaAnterior'] as String,
      grauAnterior: map['grauAnterior'] as int,
      faixaNova: map['faixaNova'] as String,
      grauNovo: map['grauNovo'] as int,
      data: DateTime.fromMillisecondsSinceEpoch(map['data'] as int),
      observacao: map['observacao'] != null
          ? map['observacao'] as String
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory HistoricoGraduacao.fromJson(String source) =>
      HistoricoGraduacao.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'HistoricoGraduacao(id: $id, faixaAnterior: $faixaAnterior, grauAnterior: $grauAnterior, faixaNova: $faixaNova, grauNovo: $grauNovo, data: $data, observacao: $observacao)';
  }

  @override
  List<Object?> get props => [
    id,
    faixaAnterior,
    grauAnterior,
    faixaNova,
    grauNovo,
    data,
    observacao,
  ];
}
