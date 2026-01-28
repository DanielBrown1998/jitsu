import '../../entities/entities.dart';

abstract class IHistoricoPresencaRepository {
  Future<void> create(String alunoId, HistoricoPresenca presenca);
}
