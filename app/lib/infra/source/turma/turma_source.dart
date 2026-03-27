import 'package:app/domain/entities/turma.dart';
import 'package:app/domain/repositories/turma/i_turma_repository.dart';
import 'package:app/core/error/exceptions.dart';
import 'package:app/infra/models/turma_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:result_dart/result_dart.dart';

abstract class TurmaSource implements ITurmaWorkflow {}

class TurmaSourceImpl implements TurmaSource {
  final FirebaseFirestore firestore;

  TurmaSourceImpl({required this.firestore});

  CollectionReference<Map<String, dynamic>> get _turmas =>
      firestore.collection('turmas');

  @override
  AsyncResult<List<Turma>> getAll() async {
    try {
      final query = await _turmas.get();
      final turmas = query.docs.map((doc) {
        final map = <String, dynamic>{...doc.data(), 'id': doc.id};
        return TurmaModel.fromMap(map).toEntity();
      }).toList();
      return Success(turmas);
    } on FirebaseException catch (e) {
      return Failure(
        DatabaseException('Falha ao listar turmas: ${e.message ?? e.code}'),
      );
    }
  }

  @override
  AsyncResult<List<Turma>> getByIds(List<String> ids) async {
    try {
      if (ids.isEmpty) {
        return const Success(<Turma>[]);
      }

      final chunks = <List<String>>[];
      for (var i = 0; i < ids.length; i += 10) {
        final end = (i + 10 < ids.length) ? i + 10 : ids.length;
        chunks.add(ids.sublist(i, end));
      }

      final result = <Turma>[];
      for (final chunk in chunks) {
        final query = await _turmas
            .where(FieldPath.documentId, whereIn: chunk)
            .get();
        result.addAll(
          query.docs.map((doc) {
            final map = <String, dynamic>{...doc.data(), 'id': doc.id};
            return TurmaModel.fromMap(map).toEntity();
          }),
        );
      }

      return Success(result);
    } on FirebaseException catch (e) {
      return Failure(
        DatabaseException(
          'Falha ao buscar turmas por IDs: ${e.message ?? e.code}',
        ),
      );
    }
  }
}
