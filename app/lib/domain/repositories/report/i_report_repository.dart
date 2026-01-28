import '../../entities/aluno.dart';

abstract class IReportRepository {
  Future<int> contarAulasPorTurma(
    String turmaId,
    DateTime inicio,
    DateTime fim,
  );
  Future<List<Aluno>> getAlunosByTurma(String turmaId);
  Future<int> contarPresencasAluno(
    String alunoId,
    String turmaId,
    DateTime inicio,
    DateTime fim,
  );
  Future<List<Aluno>> getAllAlunos();
}
