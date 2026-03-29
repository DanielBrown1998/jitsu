import 'package:app/core/error/exceptions.dart';
import 'package:app/domain/entities/professor.dart';
import 'package:app/domain/repositories/professor/i_professor_repository.dart';
import 'package:app/infra/models/professor_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:result_dart/result_dart.dart';

abstract class ProfessorSource implements IProfessorWorkflow {}

class ProfessorSourceImpl implements ProfessorSource {
  final FirebaseFirestore firestore;

  ProfessorSourceImpl({required this.firestore});

  CollectionReference<Map<String, dynamic>> get _professores =>
      firestore.collection('professores');

  @override
  AsyncResult<Professor> getById(String id) async {
    try {
      final doc = await _professores.doc(id).get();
      if (!doc.exists || doc.data() == null) {
        return Failure(DatabaseException('Professor nao encontrado: $id'));
      }

      final map = <String, dynamic>{...doc.data()!, 'id': doc.id};
      return Success(ProfessorModel.fromMap(map).toEntity());
    } on FirebaseException catch (e) {
      return Failure(
        DatabaseException('Falha ao buscar professor: ${e.message ?? e.code}'),
      );
    }
  }
}
