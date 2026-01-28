import 'package:app/core/helpers/graduacao_helper.dart';

import '../../entities/aluno.dart';
import '../../entities/status_graduacao.dart';
import '../../repositories/aluno/i_aluno_repository.dart';

class CreateAlunoParams {
  final String nome;
  final String cpf;
  final String email;
  final String dataNascimento;
  final String telefone;
  final List<String> turmasIds;
  CreateAlunoParams({
    required this.nome,
    required this.cpf,
    required this.dataNascimento,
    required this.telefone,
    required this.email,
    required this.turmasIds,
  });
}

abstract class CreateAlunoUsecase {
  Future<Aluno> call(CreateAlunoParams params);
}

/// Use Case: Criar Aluno (Exclusivo Admin/Professor)
class CreateAlunoUseCaseImpl implements CreateAlunoUsecase {
  final IAlunoRepository _repository;

  CreateAlunoUseCaseImpl(this._repository);

  @override
  Future<Aluno> call(CreateAlunoParams params) async {
    if (params.nome.trim().isEmpty) {
      throw ArgumentError('Nome do aluno é obrigatório');
    }

    final novoAluno = Aluno(
      id: params.cpf, // Será gerado pelo Firestore
      nome: params.nome.trim(),
      turmasIds: params.turmasIds,
      statusGraduacao: StatusGraduacao(
        faixaAtual: Faixa.branca.name,
        graus: 0,
        dataUltimaGraduacao: DateTime.now(),
        aulasRealizadasNestaFaixa: 0,
      ),
      email: params.email.trim(),
      telefone: params.telefone.trim(),
      dataNascimento: params.dataNascimento.trim(),
    );

    return await _repository.create(novoAluno);
  }
}
