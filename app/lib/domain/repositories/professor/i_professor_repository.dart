import 'package:app/infra/source/professor/professor_source.dart';
import 'package:result_dart/result_dart.dart';

import '../../entities/professor.dart';

abstract class IProfessorWorkflow {
  AsyncResult<Professor> getById(String id);
}

abstract class ProfessorRepository implements IProfessorWorkflow {}

class ProfessorRepositoryImpl implements ProfessorRepository {
  final ProfessorSource source;

  ProfessorRepositoryImpl({required this.source});

  @override
  AsyncResult<Professor> getById(String id) async => await source.getById(id);
}
