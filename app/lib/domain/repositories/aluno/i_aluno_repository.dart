import '../../entities/aluno.dart';
import '../../entities/historico_graduacao.dart';

abstract class IAlunoRepository {
  Future<Aluno> create(Aluno aluno);
  Future<Aluno?> getById(String id);
  Future<Aluno> update(Aluno aluno);
  Future<List<HistoricoGraduacao>> getHistorico(String alunoId);
  Future<void> saveHistoricoGraduacao(
    String alunoId,
    HistoricoGraduacao historico,
  );
}