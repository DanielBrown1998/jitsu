import 'package:app/infra/source/historico/historico_source.dart';
import 'package:result_dart/result_dart.dart';

import '../../entities/entities.dart';

abstract class IHistoricoPresencaWorkflow {
  AsyncResult<Unit> create(String alunoId, HistoricoPresenca presenca);
}

abstract class HistoricoPresencaRepository
    implements IHistoricoPresencaWorkflow {}

class HistoricoPresencaRepositoryImpl implements HistoricoPresencaRepository {
  final HistoricoPresencaSource source;

  HistoricoPresencaRepositoryImpl({required this.source});

  @override
  AsyncResult<Unit> create(String alunoId, HistoricoPresenca presenca) async =>
      await source.create(alunoId, presenca);
}
