import 'package:app/core/helpers/graduacao_helper.dart';
import 'package:result_dart/result_dart.dart';

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

class PromoteAlunoException implements Exception {
  final String message;
  PromoteAlunoException(this.message);

  @override
  String toString() => 'PromoteAlunoException: $message';
}

abstract class PromoteAlunoUseCase {
  AsyncResult<Aluno> call(PromoteAlunoParams params);
}

/// Use Case: Promover Aluno (Grau ou Faixa)
/// Ações: Zera contador, sobe grau/faixa, salva histórico
class PromoteAlunoUseCaseImpl implements PromoteAlunoUseCase {
  final AlunoRepository _repository;
  final CheckGraduationEligibilityUsecase _checkEligibility;

  PromoteAlunoUseCaseImpl(this._repository, this._checkEligibility);

  @override
  AsyncResult<Aluno> call(PromoteAlunoParams params) async {
    try {
      if (params.tipo == TipoElegibilidade.nenhum) {
        return Failure(PromoteAlunoException('Tipo de promoção inválido'));
      }

      // 1. Verificar elegibilidade (precondição)
      final elegibilidadeResult = await _checkEligibility.call(params.alunoId);
      final elegibilidade = elegibilidadeResult.fold(
        (e) => e,
        (error) => throw PromoteAlunoException(
          'Erro ao verificar elegibilidade: $error',
        ),
      );

      if (!elegibilidade.elegivel) {
        return Failure(
          PromoteAlunoException('Aluno não elegível: ${elegibilidade.motivo}'),
        );
      }

      if (elegibilidade.tipo != params.tipo) {
        return Failure(
          PromoteAlunoException(
            'Tipo de promoção incorreto. Esperado: ${elegibilidade.tipo}, '
            'Recebido: ${params.tipo}',
          ),
        );
      }

      // 2. Buscar aluno
      final alunoResult = await _repository.getById(params.alunoId);
      final aluno = alunoResult.fold(
        (a) => a,
        (e) => throw PromoteAlunoException('Erro ao buscar aluno: $e'),
      );

      if (aluno == null) {
        return Failure(PromoteAlunoException('Aluno não encontrado'));
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
          return Failure(
            PromoteAlunoException('Não há próxima faixa disponível'),
          );
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
      final alunoAtualizado = aluno.copyWith(statusGraduacao: novoStatus);
      await _repository
          .update(alunoAtualizado)
          .fold(
            (_) => null,
            (e) => throw PromoteAlunoException('Erro ao atualizar aluno: $e'),
          );

      // 4. Salvar histórico de graduação
      await _repository
          .saveHistoricoGraduacao(params.alunoId, historico)
          .fold(
            (_) => null,
            (e) => throw PromoteAlunoException('Erro ao salvar histórico: $e'),
          );

      return Success(alunoAtualizado);
    } on PromoteAlunoException catch (e) {
      return Failure(e);
    } catch (e) {
      return Failure(
        PromoteAlunoException('Erro inesperado ao promover aluno: $e'),
      );
    }
  }
}
