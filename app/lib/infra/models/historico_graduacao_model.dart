import 'dart:convert';

import '../../domain/entities/historico_graduacao.dart';

class HistoricoGraduacaoModel extends HistoricoGraduacao {
  HistoricoGraduacaoModel({
    required super.id,
    required super.faixaAnterior,
    required super.grauAnterior,
    required super.faixaNova,
    required super.grauNovo,
    required super.data,
    super.observacao,
  });

  factory HistoricoGraduacaoModel.fromEntity(HistoricoGraduacao entity) =>
      HistoricoGraduacaoModel(
        id: entity.id,
        faixaAnterior: entity.faixaAnterior,
        grauAnterior: entity.grauAnterior,
        faixaNova: entity.faixaNova,
        grauNovo: entity.grauNovo,
        data: entity.data,
        observacao: entity.observacao,
      );

  HistoricoGraduacao toEntity() => HistoricoGraduacao(
    id: id,
    faixaAnterior: faixaAnterior,
    grauAnterior: grauAnterior,
    faixaNova: faixaNova,
    grauNovo: grauNovo,
    data: data,
    observacao: observacao,
  );

  factory HistoricoGraduacaoModel.fromMap(Map<String, dynamic> map) =>
      HistoricoGraduacaoModel(
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

  factory HistoricoGraduacaoModel.fromJson(String source) =>
      HistoricoGraduacaoModel.fromMap(
        Map<String, dynamic>.from(jsonDecode(source) as Map<String, dynamic>),
      );

  @override
  String toJson() => jsonEncode(toMap());
}
