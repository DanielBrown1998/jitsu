import 'package:app/core/helpers/graduacao_helper.dart';
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

abstract class CheckGraduationEligibilityUsecase {
  Future<ElegibilidadeResult> call(String alunoId);
}

/// Use Case: Verificar Elegibilidade para Graduação
/// Regra: Compara aulas assistidas vs critérios da faixa atual
class CheckGraduationEligibilityUseCaseImpl
    implements CheckGraduationEligibilityUsecase {
  final IAlunoRepository _repository;

  CheckGraduationEligibilityUseCaseImpl(this._repository);

  @override
  Future<ElegibilidadeResult> call(String alunoId) async {
    if (alunoId.isEmpty) {
      throw ArgumentError('alunoId não pode ser vazio');
    }

    final aluno = await _repository.getById(alunoId);
    if (aluno == null) {
      throw Exception('Aluno não encontrado');
    }

    final status = aluno.statusGraduacao;
    final faixa = GraduacaoHelper.faixaFromString(status.faixaAtual);
    if (faixa == null) {
      throw Exception('Faixa inválida: ${status.faixaAtual}');
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
      return ElegibilidadeResult(
        elegivel: true,
        tipo: TipoElegibilidade.grau,
        motivo: elegGrau.motivo,
        progresso: progresso,
        proximoGrau: status.graus + 1,
      );
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
        return ElegibilidadeResult(
          elegivel: true,
          tipo: TipoElegibilidade.faixa,
          motivo: elegFaixa.motivo,
          progresso: 100,
          proximaFaixa: elegFaixa.proximaFaixa != null
              ? GraduacaoHelper.getNomeFaixa(elegFaixa.proximaFaixa!)
              : null,
        );
      }

      return ElegibilidadeResult(
        elegivel: false,
        tipo: TipoElegibilidade.faixa,
        motivo: elegFaixa.motivo,
        progresso: progresso,
        mesesRestantes: elegFaixa.mesesRestantes,
      );
    }

    // Não elegível para nada ainda
    return ElegibilidadeResult(
      elegivel: false,
      tipo: TipoElegibilidade.nenhum,
      motivo: elegGrau.motivo,
      progresso: progresso,
      aulasRestantes: elegGrau.aulasRestantes,
      mesesRestantes: elegGrau.mesesRestantes,
    );
  }
}
