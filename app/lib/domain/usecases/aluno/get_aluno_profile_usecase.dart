import 'package:app/core/helpers/graduacao_helper.dart';

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

abstract class GetAlunoProfileUsecase {
  Future<AlunoProfileResult> call(String alunoId);
}

/// Use Case: Ver Perfil do Aluno
class GetAlunoProfileUseCaseImpl implements GetAlunoProfileUsecase {
  final IAlunoRepository _repository;

  GetAlunoProfileUseCaseImpl(this._repository);

  @override
  Future<AlunoProfileResult> call(String alunoId) async {
    if (alunoId.isEmpty) {
      throw ArgumentError('alunoId não pode ser vazio');
    }

    final aluno = await _repository.getById(alunoId);
    if (aluno == null) {
      throw Exception('Aluno não encontrado');
    }

    final faixa = GraduacaoHelper.faixaFromString(
      aluno.statusGraduacao.faixaAtual,
    );
    if (faixa == null) {
      throw Exception('Faixa inválida: ${aluno.statusGraduacao.faixaAtual}');
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

    return AlunoProfileResult(
      aluno: aluno,
      progressoGrau: progresso,
      elegibilidadeGrau: elegibilidadeGrau,
      elegibilidadeFaixa: elegibilidadeFaixa,
    );
  }
}
