import 'package:app/domain/entities/aula_realizada.dart';
import 'package:app/domain/repositories/aula/i_aula_repository.dart';
import 'package:app/core/error/exceptions.dart';
import 'package:app/infra/models/aula_realizada_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:result_dart/result_dart.dart';

abstract class AulaSource implements IAulaWorkflow {}

class AulaSourceImpl implements AulaSource {
  final FirebaseFirestore firestore;

  AulaSourceImpl({required this.firestore});

  CollectionReference<Map<String, dynamic>> get _aulas =>
      firestore.collection('aulas_realizadas');

  @override
  AsyncResult<AulaRealizada> getById(String id) async {
    try {
      final doc = await _aulas.doc(id).get();
      if (!doc.exists || doc.data() == null) {
        return Failure(
          DatabaseException('Aula não encontrada: $id'),
        );
      }

      final map = <String, dynamic>{...doc.data()!, 'id': doc.id};
      return Success(AulaRealizadaModel.fromMap(map).toEntity());
    } on FirebaseException catch (e) {
      return Failure(
        DatabaseException('Falha ao buscar aula: ${e.message ?? e.code}'),
      );
    }
  }

  @override
  AsyncResult<AulaRealizada> update(AulaRealizada aula) async {
    try {
      final model = AulaRealizadaModel.fromEntity(aula);
      await _aulas.doc(model.id).set(model.toMap(), SetOptions(merge: true));
      return Success(model.toEntity());
    } on FirebaseException catch (e) {
      return Failure(
        DatabaseException('Falha ao atualizar aula: ${e.message ?? e.code}'),
      );
    }
  }

  @override
  AsyncResult<bool> verificarPresencaDuplicada(
    String alunoId,
    String turmaId,
    DateTime data,
  ) async {
    try {
      final inicioDia = DateTime(data.year, data.month, data.day);
      final fimDia = inicioDia.add(const Duration(days: 1));

      final query = await _aulas
          .where('turmaId', isEqualTo: turmaId)
          .where('alunosPresentes', arrayContains: alunoId)
          .where(
            'dataHora',
            isGreaterThanOrEqualTo: inicioDia.millisecondsSinceEpoch,
          )
          .where('dataHora', isLessThan: fimDia.millisecondsSinceEpoch)
          .limit(1)
          .get();

      return Success(query.docs.isNotEmpty);
    } on FirebaseException catch (e) {
      return Failure(
        DatabaseException(
          'Falha ao verificar presença duplicada: ${e.message ?? e.code}',
        ),
      );
    }
  }
}
