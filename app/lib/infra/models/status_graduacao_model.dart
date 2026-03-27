import 'dart:convert';

import '../../domain/entities/status_graduacao.dart';

class StatusGraduacaoModel extends StatusGraduacao {
  StatusGraduacaoModel({
    required super.faixaAtual,
    required super.graus,
    required super.dataUltimaGraduacao,
    required super.aulasRealizadasNestaFaixa,
  });

  factory StatusGraduacaoModel.fromEntity(StatusGraduacao entity) =>
      StatusGraduacaoModel(
        faixaAtual: entity.faixaAtual,
        graus: entity.graus,
        dataUltimaGraduacao: entity.dataUltimaGraduacao,
        aulasRealizadasNestaFaixa: entity.aulasRealizadasNestaFaixa,
      );

  StatusGraduacao toEntity() => StatusGraduacao(
    faixaAtual: faixaAtual,
    graus: graus,
    dataUltimaGraduacao: dataUltimaGraduacao,
    aulasRealizadasNestaFaixa: aulasRealizadasNestaFaixa,
  );

  factory StatusGraduacaoModel.fromMap(Map<String, dynamic> map) =>
      StatusGraduacaoModel(
        faixaAtual: map['faixaAtual'] as String,
        graus: map['graus'] as int,
        dataUltimaGraduacao: DateTime.fromMillisecondsSinceEpoch(
          map['dataUltimaGraduacao'] as int,
        ),
        aulasRealizadasNestaFaixa: map['aulasRealizadasNestaFaixa'] as int,
      );

  factory StatusGraduacaoModel.fromJson(String source) =>
      StatusGraduacaoModel.fromMap(
        Map<String, dynamic>.from(jsonDecode(source) as Map<String, dynamic>),
      );

  @override
  String toJson() => jsonEncode(toMap());
}
