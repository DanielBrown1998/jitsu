import 'package:app/infra/source/aluno/aluno_source.dart';
import 'package:result_dart/result_dart.dart';

import '../../entities/aluno.dart';
import '../../entities/historico_graduacao.dart';

abstract class IAlunoWorkflow {
  AsyncResult<Aluno> create(Aluno aluno);
  AsyncResult<Aluno> getById(String id);
  AsyncResult<Aluno> update(Aluno aluno);
  AsyncResult<List<HistoricoGraduacao>> getHistorico(String alunoId);
  AsyncResult<Unit> saveHistoricoGraduacao(
    String alunoId,
    HistoricoGraduacao historico,
  );
}

abstract class AlunoRepository implements IAlunoWorkflow {}

class AlunoRepositoryImpl implements AlunoRepository {
  final AlunoSource source;

  AlunoRepositoryImpl({required this.source});
  @override
  AsyncResult<Aluno> create(Aluno aluno) async => await source.create(aluno);

  @override
  AsyncResult<Aluno> getById(String id) async => await source.getById(id);

  @override
  AsyncResult<List<HistoricoGraduacao>> getHistorico(String alunoId) async =>
      await source.getHistorico(alunoId);

  @override
  AsyncResult<Unit> saveHistoricoGraduacao(
    String alunoId,
    HistoricoGraduacao historico,
  ) async => await source.saveHistoricoGraduacao(alunoId, historico);

  @override
  AsyncResult<Aluno> update(Aluno aluno) async => await source.update(aluno);
}
