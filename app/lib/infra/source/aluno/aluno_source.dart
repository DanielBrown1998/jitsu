import 'package:app/domain/entities/aluno.dart';
import 'package:app/domain/entities/historico_graduacao.dart';
import 'package:app/domain/repositories/aluno/i_aluno_repository.dart';
import 'package:app/core/error/exceptions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:app/infra/models/aluno_model.dart';
import 'package:app/infra/models/historico_graduacao_model.dart';
import 'package:result_dart/result_dart.dart';

abstract class AlunoSource implements IAlunoWorkflow {}

class AlunoSourceImpl implements AlunoSource {
  final FirebaseFirestore firestore;

  AlunoSourceImpl({required this.firestore});

  CollectionReference<Map<String, dynamic>> get _alunos =>
      firestore.collection('alunos');

  CollectionReference<Map<String, dynamic>> get _historicosGraduacao =>
      firestore.collection('historicos_graduacao');

  @override
  AsyncResult<Aluno> create(Aluno aluno) async {
    try {
      final model = AlunoModel.fromEntity(aluno);
      await _alunos.doc(model.id).set(model.toMap());
      return Success(model.toEntity());
    } on FirebaseException catch (e) {
      return Failure(
        DatabaseException('Falha ao criar aluno: ${e.message ?? e.code}'),
      );
    }
  }

  @override
  AsyncResult<Aluno> getById(String id) async {
    try {
      final doc = await _alunos.doc(id).get();
      if (!doc.exists || doc.data() == null) {
        return Failure(
          DatabaseException('Aluno não encontrado: $id'),
        );
      }

      final map = <String, dynamic>{...doc.data()!, 'id': doc.id};
      return Success(AlunoModel.fromMap(map).toEntity());
    } on FirebaseException catch (e) {
      return Failure(
        DatabaseException('Falha ao buscar aluno: ${e.message ?? e.code}'),
      );
    }
  }

  @override
  AsyncResult<List<HistoricoGraduacao>> getHistorico(String alunoId) async {
    try {
      final query = await _historicosGraduacao
          .where('alunoId', isEqualTo: alunoId)
          .orderBy('data', descending: true)
          .get();

      final historico = query.docs.map((doc) {
        final data = doc.data();
        final map = <String, dynamic>{...data, 'id': doc.id};
        map.remove('alunoId');
        return HistoricoGraduacaoModel.fromMap(map).toEntity();
      }).toList();
      return Success(historico);
    } on FirebaseException catch (e) {
      return Failure(
        DatabaseException(
          'Falha ao buscar histórico de graduação: ${e.message ?? e.code}',
        ),
      );
    }
  }

  @override
  AsyncResult<Unit> saveHistoricoGraduacao(
    String alunoId,
    HistoricoGraduacao historico,
  ) async {
    try {
      final model = HistoricoGraduacaoModel.fromEntity(historico);
      final docRef = model.id.isEmpty
          ? _historicosGraduacao.doc()
          : _historicosGraduacao.doc(model.id);
      await docRef.set({...model.toMap(), 'alunoId': alunoId, 'id': docRef.id});
      return const Success(unit);
    } on FirebaseException catch (e) {
      return Failure(
        DatabaseException(
          'Falha ao salvar histórico de graduação: ${e.message ?? e.code}',
        ),
      );
    }
  }

  @override
  AsyncResult<Aluno> update(Aluno aluno) async {
    try {
      final model = AlunoModel.fromEntity(aluno);
      await _alunos.doc(model.id).update(model.toMap());
      return Success(model.toEntity());
    } on FirebaseException catch (e) {
      return Failure(
        DatabaseException('Falha ao atualizar aluno: ${e.message ?? e.code}'),
      );
    }
  }
}
