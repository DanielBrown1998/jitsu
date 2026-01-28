import 'package:app/core/helpers/graduacao_helper.dart';
import '../../entities/aluno.dart';
import '../../entities/historico_graduacao.dart';
import '../../entities/status_graduacao.dart';
import '../../repositories/aluno/i_aluno_repository.dart';
import 'check_graduation_eligibility_usecase.dart';

class PromoteAlunoParams {
  final String alunoId;
  final TipoElegibilidade tipo;
  final String? observacao;

  PromoteAlunoParams({
    required this.alunoId,
    required this.tipo,
    this.observacao,
  });
}

abstract class PromoteAlunoUseCase {
  Future<Aluno> call(PromoteAlunoParams params);
}

/// Use Case: Promover Aluno (Grau ou Faixa)
/// Ações: Zera contador, sobe grau/faixa, salva histórico
class PromoteAlunoUseCaseImpl implements PromoteAlunoUseCase {
  final IAlunoRepository _repository;
  final CheckGraduationEligibilityUsecase _checkEligibility;

  PromoteAlunoUseCaseImpl(this._repository, this._checkEligibility);

  @override
  Future<Aluno> call(PromoteAlunoParams params) async {
    if (params.tipo == TipoElegibilidade.nenhum) {
      throw ArgumentError('Tipo de promoção inválido');
    }

    // 1. Verificar elegibilidade (precondição)
    final elegibilidade = await _checkEligibility.call(params.alunoId);

    if (!elegibilidade.elegivel) {
      throw Exception('Aluno não elegível: ${elegibilidade.motivo}');
    }

    if (elegibilidade.tipo != params.tipo) {
      throw Exception(
        'Tipo de promoção incorreto. Esperado: ${elegibilidade.tipo}, '
        'Recebido: ${params.tipo}',
      );
    }

    // 2. Buscar aluno
    final aluno = await _repository.getById(params.alunoId);
    if (aluno == null) {
      throw Exception('Aluno não encontrado');
    }

    final statusAtual = aluno.statusGraduacao;
    late StatusGraduacao novoStatus;
    late HistoricoGraduacao historico;

    if (params.tipo == TipoElegibilidade.grau) {
      // PROMOÇÃO DE GRAU
      novoStatus = StatusGraduacao(
        faixaAtual: statusAtual.faixaAtual,
        graus: statusAtual.graus + 1,
        dataUltimaGraduacao: DateTime.now(),
        aulasRealizadasNestaFaixa: 0, // ZERAR CONTADOR
      );

      historico = HistoricoGraduacao(
        id: '${params.alunoId}_${DateTime.now().millisecondsSinceEpoch}',
        faixaAnterior: statusAtual.faixaAtual,
        grauAnterior: statusAtual.graus,
        faixaNova: statusAtual.faixaAtual,
        grauNovo: statusAtual.graus + 1,
        data: DateTime.now(),
        observacao: params.observacao,
      );
    } else {
      // PROMOÇÃO DE FAIXA
      final faixaAtualEnum = GraduacaoHelper.faixaFromString(
        statusAtual.faixaAtual,
      );
      final criterio = GraduacaoHelper.getCriterio(faixaAtualEnum!);
      final proximaFaixa = criterio?.proximaFaixa;

      if (proximaFaixa == null) {
        throw Exception('Não há próxima faixa disponível');
      }

      final nomeFaixaNova = GraduacaoHelper.getNomeFaixa(proximaFaixa);

      novoStatus = StatusGraduacao(
        faixaAtual: nomeFaixaNova,
        graus: 0, // RESETAR GRAU
        dataUltimaGraduacao: DateTime.now(),
        aulasRealizadasNestaFaixa: 0, // ZERAR CONTADOR
      );

      historico = HistoricoGraduacao(
        id: '${params.alunoId}_${DateTime.now().millisecondsSinceEpoch}',
        faixaAnterior: statusAtual.faixaAtual,
        grauAnterior: statusAtual.graus,
        faixaNova: nomeFaixaNova,
        grauNovo: 0,
        data: DateTime.now(),
        observacao: params.observacao,
      );
    }

    // 3. Atualizar aluno
    final alunoAtualizado = aluno.copyWith(
      statusGraduacao: novoStatus,
    );
    await _repository.update(alunoAtualizado);

    // 4. Salvar histórico de graduação
    await _repository.saveHistoricoGraduacao(params.alunoId, historico);

    return alunoAtualizado;
  }
}
