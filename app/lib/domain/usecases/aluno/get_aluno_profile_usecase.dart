import 'package:app/core/helpers/graduacao_helper.dart';
import 'package:result_dart/result_dart.dart';

import '../../entities/aluno.dart';
import '../../repositories/aluno/i_aluno_repository.dart';

class AlunoProfileResult {
  final Aluno aluno;
  final double progressoGrau;
  final ElegibilidadeGrau elegibilidadeGrau;
  final ElegibilidadeFaixa elegibilidadeFaixa;

  AlunoProfileResult({
    required this.aluno,
    required this.progressoGrau,
    required this.elegibilidadeGrau,
    required this.elegibilidadeFaixa,
  });
}

class GetAlunoProfileException implements Exception {
  final String message;
  GetAlunoProfileException(this.message);

  @override
  String toString() => 'GetAlunoProfileException: $message';
}

abstract class GetAlunoProfileUsecase {
  AsyncResult<AlunoProfileResult> call(String alunoId);
}

/// Use Case: Ver Perfil do Aluno
class GetAlunoProfileUseCaseImpl implements GetAlunoProfileUsecase {
  final AlunoRepository _repository;

  GetAlunoProfileUseCaseImpl(this._repository);

  @override
  AsyncResult<AlunoProfileResult> call(String alunoId) async {
    if (alunoId.isEmpty) {
      return Failure(GetAlunoProfileException('alunoId não pode ser vazio'));
    }

    return await _repository.getById(alunoId).fold(
      (aluno) {

        final faixa = GraduacaoHelper.faixaFromString(
          aluno.statusGraduacao.faixaAtual,
        );
        if (faixa == null) {
          return Failure(GetAlunoProfileException(
            'Faixa inválida: ${aluno.statusGraduacao.faixaAtual}',
          ));
        }

        // Calcular progresso
        final progresso = GraduacaoHelper.calcularProgressoGrau(
          faixaAtual: faixa,
          aulasRealizadas: aluno.statusGraduacao.aulasRealizadasNestaFaixa,
          dataUltimaGraduacao: aluno.statusGraduacao.dataUltimaGraduacao,
        );

        // Verificar elegibilidade para grau
        final elegibilidadeGrau = GraduacaoHelper.verificarElegibilidadeGrau(
          faixaAtual: faixa,
          grauAtual: aluno.statusGraduacao.graus,
          aulasRealizadas: aluno.statusGraduacao.aulasRealizadasNestaFaixa,
          dataUltimaGraduacao: aluno.statusGraduacao.dataUltimaGraduacao,
        );

        // Verificar elegibilidade para faixa (assumindo idade 18 por padrão)
        final elegibilidadeFaixa = GraduacaoHelper.verificarElegibilidadeFaixa(
          faixaAtual: faixa,
          grauAtual: aluno.statusGraduacao.graus,
          dataUltimaGraduacao: aluno.statusGraduacao.dataUltimaGraduacao,
          idadeAluno: 18,
        );

        return Success(AlunoProfileResult(
          aluno: aluno,
          progressoGrau: progresso,
          elegibilidadeGrau: elegibilidadeGrau,
          elegibilidadeFaixa: elegibilidadeFaixa,
        ));
      },
      (error) => Failure(GetAlunoProfileException(
        'Erro ao buscar perfil do aluno: ${error.toString()}',
      )),
    );
  }
}
