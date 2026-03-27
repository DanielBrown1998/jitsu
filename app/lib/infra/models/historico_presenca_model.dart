import 'dart:convert';

import '../../domain/entities/historico_presenca.dart';

class HistoricoPresencaModel extends HistoricoPresenca {
  HistoricoPresencaModel({
    required super.id,
    required super.data,
    required super.turmaId,
    super.tecnicaAprendida,
  });

  factory HistoricoPresencaModel.fromEntity(HistoricoPresenca entity) =>
      HistoricoPresencaModel(
        id: entity.id,
        data: entity.data,
        turmaId: entity.turmaId,
        tecnicaAprendida: entity.tecnicaAprendida,
      );

  HistoricoPresenca toEntity() => HistoricoPresenca(
    id: id,
    data: data,
    turmaId: turmaId,
    tecnicaAprendida: tecnicaAprendida,
  );

  factory HistoricoPresencaModel.fromMap(Map<String, dynamic> map) =>
      HistoricoPresencaModel(
        id: map['id'] as String,
        data: DateTime.fromMillisecondsSinceEpoch(map['data'] as int),
        turmaId: map['turmaId'] as String,
        tecnicaAprendida: map['tecnicaAprendida'] != null
            ? map['tecnicaAprendida'] as String
            : null,
      );

  factory HistoricoPresencaModel.fromJson(String source) =>
      HistoricoPresencaModel.fromMap(
        Map<String, dynamic>.from(jsonDecode(source) as Map<String, dynamic>),
      );

  @override
  String toJson() => jsonEncode(toMap());
}
