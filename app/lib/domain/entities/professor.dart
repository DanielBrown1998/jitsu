// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:collection/collection.dart';

class Professor {
  final String id;
  final String nome;
  final List<String> turmasIds;
  final bool isAtivo;

  Professor({
    required this.id,
    required this.nome,
    required this.turmasIds,
    required this.isAtivo,
  });

  Professor copyWith({
    String? id,
    String? nome,
    List<String>? turmasIds,
    bool? isAtivo,
  }) {
    return Professor(
      id: id ?? this.id,
      nome: nome ?? this.nome,
      turmasIds: turmasIds ?? this.turmasIds,
      isAtivo: isAtivo ?? this.isAtivo,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'nome': nome,
      'turmasIds': turmasIds,
      'isAtivo': isAtivo,
    };
  }

  factory Professor.fromMap(Map<String, dynamic> map) {
    return Professor(
      id: map['id'] as String,
      nome: map['nome'] as String,
      turmasIds: List<String>.from((map['turmasIds'] as List<String>)),
      isAtivo: map['isAtivo'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory Professor.fromJson(String source) => Professor.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Professor(id: $id, nome: $nome, turmasIds: $turmasIds, isAtivo: $isAtivo)';
  }

  @override
  bool operator ==(covariant Professor other) {
    if (identical(this, other)) return true;
    final listEquals = const DeepCollectionEquality().equals;
  
    return 
      other.id == id &&
      other.nome == nome &&
      listEquals(other.turmasIds, turmasIds) &&
      other.isAtivo == isAtivo;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      nome.hashCode ^
      turmasIds.hashCode ^
      isAtivo.hashCode;
  }
}
