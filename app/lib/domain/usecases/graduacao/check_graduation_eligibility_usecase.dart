import 'package:app/core/helpers/graduacao_helper.dart';
import 'package:result_dart/result_dart.dart';

import '../../repositories/aluno/i_aluno_repository.dart';

enum TipoElegibilidade { grau, faixa, nenhum }

class ElegibilidadeResult {
  final bool elegivel;
  final TipoElegibilidade tipo;
  final String motivo;
  final double progresso;
  final int? aulasRestantes;
  final int? mesesRestantes;
  final String? proximaFaixa;
  final int? proximoGrau;

  ElegibilidadeResult({
    required this.elegivel,
    required this.tipo,
    required this.motivo,
    required this.progresso,
    this.aulasRestantes,
    this.mesesRestantes,
    this.proximaFaixa,
    this.proximoGrau,
  });
}

class CheckGraduationEligibilityException implements Exception {
  final String message;
  CheckGraduationEligibilityException(this.message);

  @override
  String toString() => 'CheckGraduationEligibilityException: $message';
}

abstract class CheckGraduationEligibilityUsecase {
  AsyncResult<ElegibilidadeResult> call(String alunoId);
}

/// Use Case: Verificar Elegibilidade para Graduação
/// Regra: Compara aulas assistidas vs critérios da faixa atual
class CheckGraduationEligibilityUseCaseImpl
    implements CheckGraduationEligibilityUsecase {
  final AlunoRepository _repository;

  CheckGraduationEligibilityUseCaseImpl(this._repository);

  @override
  AsyncResult<ElegibilidadeResult> call(String alunoId) async {
    if (alunoId.isEmpty) {
      return Failure(
        CheckGraduationEligibilityException('alunoId não pode ser vazio'),
      );
    }

    return await _repository.getById(alunoId).fold(
      (aluno) {
        final status = aluno.statusGraduacao;
        final faixa = GraduacaoHelper.faixaFromString(status.faixaAtual);
        if (faixa == null) {
          return Failure(
            CheckGraduationEligibilityException(
              'Faixa inválida: ${status.faixaAtual}',
            ),
          );
        }

        // Calcular progresso atual
        final progresso = GraduacaoHelper.calcularProgressoGrau(
          faixaAtual: faixa,
          aulasRealizadas: status.aulasRealizadasNestaFaixa,
          dataUltimaGraduacao: status.dataUltimaGraduacao,
        );

        // Verificar elegibilidade para GRAU
        final elegGrau = GraduacaoHelper.verificarElegibilidadeGrau(
          faixaAtual: faixa,
          grauAtual: status.graus,
          aulasRealizadas: status.aulasRealizadasNestaFaixa,
          dataUltimaGraduacao: status.dataUltimaGraduacao,
        );

        if (elegGrau.elegivel) {
          return Success(ElegibilidadeResult(
            elegivel: true,
            tipo: TipoElegibilidade.grau,
            motivo: elegGrau.motivo,
            progresso: progresso,
            proximoGrau: status.graus + 1,
          ));
        }

        // Se pronto para próxima faixa
        if (elegGrau.prontoParaProximaFaixa) {
          final elegFaixa = GraduacaoHelper.verificarElegibilidadeFaixa(
            faixaAtual: faixa,
            grauAtual: status.graus,
            dataUltimaGraduacao: status.dataUltimaGraduacao,
            idadeAluno:
                DateTime.now()
                    .difference(DateTime.parse(aluno.dataNascimento))
                    .inDays ~/
                365,
          );

          if (elegFaixa.elegivel) {
            return Success(ElegibilidadeResult(
              elegivel: true,
              tipo: TipoElegibilidade.faixa,
              motivo: elegFaixa.motivo,
              progresso: 100,
              proximaFaixa: elegFaixa.proximaFaixa != null
                  ? GraduacaoHelper.getNomeFaixa(elegFaixa.proximaFaixa!)
                  : null,
            ));
          }

          return Success(ElegibilidadeResult(
            elegivel: false,
            tipo: TipoElegibilidade.faixa,
            motivo: elegFaixa.motivo,
            progresso: progresso,
            mesesRestantes: elegFaixa.mesesRestantes,
          ));
        }

        // Não elegível para nada ainda
        return Success(ElegibilidadeResult(
          elegivel: false,
          tipo: TipoElegibilidade.nenhum,
          motivo: elegGrau.motivo,
          progresso: progresso,
          aulasRestantes: elegGrau.aulasRestantes,
          mesesRestantes: elegGrau.mesesRestantes,
        ));
      },
      (error) => Failure(
        CheckGraduationEligibilityException(
          'Erro ao verificar elegibilidade: ${error.toString()}',
        ),
      ),
    );
  }
}

