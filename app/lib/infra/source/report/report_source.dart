import 'package:app/domain/entities/aluno.dart';
import 'package:app/domain/repositories/report/i_report_repository.dart';
import 'package:app/core/error/exceptions.dart';
import 'package:app/infra/models/aluno_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:result_dart/result_dart.dart';

abstract class ReportSource implements IReportWorkflow {}

class ReportSourceImpl implements ReportSource {
  final FirebaseFirestore firestore;

  ReportSourceImpl({required this.firestore});

  CollectionReference<Map<String, dynamic>> get _alunos =>
      firestore.collection('alunos');
  CollectionReference<Map<String, dynamic>> get _aulas =>
      firestore.collection('aulas_realizadas');

  @override
  AsyncResult<int> contarAulasPorTurma(
    String turmaId,
    DateTime inicio,
    DateTime fim,
  ) async {
    try {
      final query = await _aulas
          .where('turmaId', isEqualTo: turmaId)
          .where(
            'dataHora',
            isGreaterThanOrEqualTo: inicio.millisecondsSinceEpoch,
          )
          .where('dataHora', isLessThanOrEqualTo: fim.millisecondsSinceEpoch)
          .get();
      return Success(query.docs.length);
    } on FirebaseException catch (e) {
      return Failure(
        DatabaseException(
          'Falha ao contar aulas por turma: ${e.message ?? e.code}',
        ),
      );
    }
  }

  @override
  AsyncResult<List<Aluno>> getAlunosByTurma(String turmaId) async {
    try {
      final query = await _alunos
          .where('turmasIds', arrayContains: turmaId)
          .get();
      final alunos = query.docs.map((doc) {
        final map = <String, dynamic>{...doc.data(), 'id': doc.id};
        return AlunoModel.fromMap(map).toEntity();
      }).toList();
      return Success(alunos);
    } on FirebaseException catch (e) {
      return Failure(
        DatabaseException(
          'Falha ao listar alunos por turma: ${e.message ?? e.code}',
        ),
      );
    }
  }

  @override
  AsyncResult<int> contarPresencasAluno(
    String alunoId,
    String turmaId,
    DateTime inicio,
    DateTime fim,
  ) async {
    try {
      final query = await _aulas
          .where('turmaId', isEqualTo: turmaId)
          .where('alunosPresentes', arrayContains: alunoId)
          .where(
            'dataHora',
            isGreaterThanOrEqualTo: inicio.millisecondsSinceEpoch,
          )
          .where('dataHora', isLessThanOrEqualTo: fim.millisecondsSinceEpoch)
          .get();

      return Success(query.docs.length);
    } on FirebaseException catch (e) {
      return Failure(
        DatabaseException(
          'Falha ao contar presenças do aluno: ${e.message ?? e.code}',
        ),
      );
    }
  }

  @override
  AsyncResult<List<Aluno>> getAllAlunos() async {
    try {
      final query = await _alunos.get();
      final alunos = query.docs.map((doc) {
        final map = <String, dynamic>{...doc.data(), 'id': doc.id};
        return AlunoModel.fromMap(map).toEntity();
      }).toList();
      return Success(alunos);
    } on FirebaseException catch (e) {
      return Failure(
        DatabaseException(
          'Falha ao listar todos os alunos: ${e.message ?? e.code}',
        ),
      );
    }
  }
}
