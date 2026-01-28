import '../../entities/turma.dart';

abstract class ITurmaRepository {
  Future<List<Turma>> getAll();
  Future<List<Turma>> getByIds(List<String> ids);
}
