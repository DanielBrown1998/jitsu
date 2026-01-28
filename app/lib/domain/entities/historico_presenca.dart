// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class HistoricoPresenca {
  final String id;
  final DateTime data;
  final String turmaId;
  final String? tecnicaAprendida;

  HistoricoPresenca({
    required this.id,
    required this.data,
    required this.turmaId,
    this.tecnicaAprendida,
  });

  HistoricoPresenca copyWith({
    String? id,
    DateTime? data,
    String? turmaId,
    String? tecnicaAprendida,
  }) {
    return HistoricoPresenca(
      id: id ?? this.id,
      data: data ?? this.data,
      turmaId: turmaId ?? this.turmaId,
      tecnicaAprendida: tecnicaAprendida ?? this.tecnicaAprendida,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'data': data.millisecondsSinceEpoch,
      'turmaId': turmaId,
      'tecnicaAprendida': tecnicaAprendida,
    };
  }

  factory HistoricoPresenca.fromMap(Map<String, dynamic> map) {
    return HistoricoPresenca(
      id: map['id'] as String,
      data: DateTime.fromMillisecondsSinceEpoch(map['data'] as int),
      turmaId: map['turmaId'] as String,
      tecnicaAprendida: map['tecnicaAprendida'] != null ? map['tecnicaAprendida'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory HistoricoPresenca.fromJson(String source) => HistoricoPresenca.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'HistoricoPresenca(id: $id, data: $data, turmaId: $turmaId, tecnicaAprendida: $tecnicaAprendida)';
  }

  @override
  bool operator ==(covariant HistoricoPresenca other) {
    if (identical(this, other)) return true;
  
    return 
      other.id == id &&
      other.data == data &&
      other.turmaId == turmaId &&
      other.tecnicaAprendida == tecnicaAprendida;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      data.hashCode ^
      turmaId.hashCode ^
      tecnicaAprendida.hashCode;
  }
}
