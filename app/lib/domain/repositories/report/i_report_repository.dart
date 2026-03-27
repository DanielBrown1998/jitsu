import 'package:app/infra/source/report/report_source.dart';
import 'package:result_dart/result_dart.dart';

import '../../entities/aluno.dart';

abstract class IReportWorkflow {
  AsyncResult<int> contarAulasPorTurma(
    String turmaId,
    DateTime inicio,
    DateTime fim,
  );
  AsyncResult<List<Aluno>> getAlunosByTurma(String turmaId);
  AsyncResult<int> contarPresencasAluno(
    String alunoId,
    String turmaId,
    DateTime inicio,
    DateTime fim,
  );
  AsyncResult<List<Aluno>> getAllAlunos();
}

abstract class ReportRepository implements IReportWorkflow {}

class ReportRepositoryImpl implements ReportRepository {
  final ReportSource source;

  ReportRepositoryImpl({required this.source});

  @override
  AsyncResult<int> contarAulasPorTurma(
    String turmaId,
    DateTime inicio,
    DateTime fim,
  ) async => await source.contarAulasPorTurma(turmaId, inicio, fim);

  @override
  AsyncResult<int> contarPresencasAluno(
    String alunoId,
    String turmaId,
    DateTime inicio,
    DateTime fim,
  ) async => await source.contarPresencasAluno(alunoId, turmaId, inicio, fim);

  @override
  AsyncResult<List<Aluno>> getAllAlunos() async => await source.getAllAlunos();

  @override
  AsyncResult<List<Aluno>> getAlunosByTurma(String turmaId) async =>
      await source.getAlunosByTurma(turmaId);
}
