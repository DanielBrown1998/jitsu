import '../../entities/aula_realizada.dart';

abstract class IAulaRepository {
  Future<AulaRealizada?> getById(String id);
  Future<AulaRealizada> update(AulaRealizada aula);
  Future<bool> verificarPresencaDuplicada(
    String alunoId,
    String turmaId,
    DateTime data,
  );
}