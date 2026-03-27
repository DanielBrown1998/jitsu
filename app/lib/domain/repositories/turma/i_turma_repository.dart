import 'package:app/infra/source/turma/turma_source.dart';
import 'package:result_dart/result_dart.dart';

import '../../entities/turma.dart';

abstract class ITurmaWorkflow {
  AsyncResult<List<Turma>> getAll();
  AsyncResult<List<Turma>> getByIds(List<String> ids);
}

abstract class TurmaRepository implements ITurmaWorkflow {}

class TurmaRepositoryImpl implements TurmaRepository {
  final TurmaSource source;

  TurmaRepositoryImpl({required this.source});

  @override
  AsyncResult<List<Turma>> getAll() async => await source.getAll();

  @override
  AsyncResult<List<Turma>> getByIds(List<String> ids) async =>
      await source.getByIds(ids);
}
