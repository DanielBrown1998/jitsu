// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class StatusGraduacao {
  final String faixaAtual;
  final int graus; // 0 a 4
  final DateTime dataUltimaGraduacao;
  final int aulasRealizadasNestaFaixa;

  StatusGraduacao({
    required this.faixaAtual,
    required this.graus,
    required this.dataUltimaGraduacao,
    required this.aulasRealizadasNestaFaixa,
  });

  StatusGraduacao copyWith({
    String? faixaAtual,
    int? graus,
    DateTime? dataUltimaGraduacao,
    int? aulasRealizadasNestaFaixa,
  }) {
    return StatusGraduacao(
      faixaAtual: faixaAtual ?? this.faixaAtual,
      graus: graus ?? this.graus,
      dataUltimaGraduacao: dataUltimaGraduacao ?? this.dataUltimaGraduacao,
      aulasRealizadasNestaFaixa:
          aulasRealizadasNestaFaixa ?? this.aulasRealizadasNestaFaixa,
    );
  }

  StatusGraduacao incrementarAula() {
    return copyWith(aulasRealizadasNestaFaixa: aulasRealizadasNestaFaixa + 1);
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'faixaAtual': faixaAtual,
      'graus': graus,
      'dataUltimaGraduacao': dataUltimaGraduacao.millisecondsSinceEpoch,
      'aulasRealizadasNestaFaixa': aulasRealizadasNestaFaixa,
    };
  }

  factory StatusGraduacao.fromMap(Map<String, dynamic> map) {
    return StatusGraduacao(
      faixaAtual: map['faixaAtual'] as String,
      graus: map['graus'] as int,
      dataUltimaGraduacao: DateTime.fromMillisecondsSinceEpoch(
        map['dataUltimaGraduacao'] as int,
      ),
      aulasRealizadasNestaFaixa: map['aulasRealizadasNestaFaixa'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory StatusGraduacao.fromJson(String source) =>
      StatusGraduacao.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'StatusGraduacao(faixaAtual: $faixaAtual, graus: $graus, dataUltimaGraduacao: $dataUltimaGraduacao, aulasRealizadasNestaFaixa: $aulasRealizadasNestaFaixa)';
  }

  @override
  bool operator ==(covariant StatusGraduacao other) {
    if (identical(this, other)) return true;

    return other.faixaAtual == faixaAtual &&
        other.graus == graus &&
        other.dataUltimaGraduacao == dataUltimaGraduacao &&
        other.aulasRealizadasNestaFaixa == aulasRealizadasNestaFaixa;
  }

  @override
  int get hashCode {
    return faixaAtual.hashCode ^
        graus.hashCode ^
        dataUltimaGraduacao.hashCode ^
        aulasRealizadasNestaFaixa.hashCode;
  }
}
