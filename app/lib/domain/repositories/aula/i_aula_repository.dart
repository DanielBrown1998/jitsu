import 'package:app/infra/source/aula/aula_source.dart';
import 'package:result_dart/result_dart.dart';

import '../../entities/aula_realizada.dart';

abstract class IAulaWorkflow {
  AsyncResult<AulaRealizada> getById(String id);
  AsyncResult<AulaRealizada> update(AulaRealizada aula);
  AsyncResult<bool> verificarPresencaDuplicada(
    String alunoId,
    String turmaId,
    DateTime data,
  );
}

abstract class AulaRepository implements IAulaWorkflow {}

class AulaRepositoryImpl implements AulaRepository {
  final AulaSource source;

  AulaRepositoryImpl({required this.source});

  @override
  AsyncResult<AulaRealizada> getById(String id) async =>
      await source.getById(id);

  @override
  AsyncResult<AulaRealizada> update(AulaRealizada aula) async =>
      await source.update(aula);

  @override
  AsyncResult<bool> verificarPresencaDuplicada(
    String alunoId,
    String turmaId,
    DateTime data,
  ) async => await source.verificarPresencaDuplicada(alunoId, turmaId, data);
}
