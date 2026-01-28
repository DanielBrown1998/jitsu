import 'package:app/core/helpers/graduacao_helper.dart';

import '../../repositories/report/i_report_repository.dart';
import '../../repositories/turma/i_turma_repository.dart';

class GenerateTurmaReportParams {
  final String turmaId;
  final DateTime dataInicio;
  final DateTime dataFim;

  GenerateTurmaReportParams({
    required this.turmaId,
    required this.dataInicio,
    required this.dataFim,
  });
}

class AlunoReportItem {
  final String alunoId;
  final String nome;
  final String faixa;
  final int grau;
  final int presencas;
  final double frequenciaPercent;
  final bool elegivelGraduacao;

  AlunoReportItem({
    required this.alunoId,
    required this.nome,
    required this.faixa,
    required this.grau,
    required this.presencas,
    required this.frequenciaPercent,
    required this.elegivelGraduacao,
  });
}

class TurmaReport {
  final String turmaId;
  final String nomeTurma;
  final DateTime dataInicio;
  final DateTime dataFim;
  final int totalAulas;
  final int totalAlunos;
  final double mediaPresenca;
  final List<AlunoReportItem> alunos;
  final List<String> alunosElegiveis;

  TurmaReport({
    required this.turmaId,
    required this.nomeTurma,
    required this.dataInicio,
    required this.dataFim,
    required this.totalAulas,
    required this.totalAlunos,
    required this.mediaPresenca,
    required this.alunos,
    required this.alunosElegiveis,
  });
}

abstract class IGenerateTurmaReportUseCase {
  Future<TurmaReport> call(GenerateTurmaReportParams params);
}

/// Use Case: Gerar Relatório da Turma
class GenerateTurmaReportUseCase implements IGenerateTurmaReportUseCase {
  final ITurmaRepository _turmaRepository;
  final IReportRepository _reportRepository;

  GenerateTurmaReportUseCase(this._turmaRepository, this._reportRepository);

  @override
  Future<TurmaReport> call(GenerateTurmaReportParams params) async {
    // Buscar turma
    final turmas = await _turmaRepository.getByIds([params.turmaId]);
    if (turmas.isEmpty) {
      throw Exception('Turma não encontrada');
    }
    final turma = turmas.first;

    // Contar total de aulas no período
    final totalAulas = await _reportRepository.contarAulasPorTurma(
      params.turmaId,
      params.dataInicio,
      params.dataFim,
    );

    // Buscar alunos da turma
    final alunos = await _reportRepository.getAlunosByTurma(params.turmaId);

    final List<AlunoReportItem> alunosReport = [];
    final List<String> alunosElegiveis = [];
    double somaFrequencia = 0;

    for (final aluno in alunos) {
      // Contar presenças do aluno
      final presencas = await _reportRepository.contarPresencasAluno(
        aluno.id,
        params.turmaId,
        params.dataInicio,
        params.dataFim,
      );

      final frequencia = totalAulas > 0 ? (presencas / totalAulas) * 100 : 0.0;
      somaFrequencia += frequencia;

      // Verificar elegibilidade
      final faixa = GraduacaoHelper.faixaFromString(
        aluno.statusGraduacao.faixaAtual,
      );
      bool elegivel = false;

      if (faixa != null) {
        final eleg = GraduacaoHelper.verificarElegibilidadeGrau(
          faixaAtual: faixa,
          grauAtual: aluno.statusGraduacao.graus,
          aulasRealizadas: aluno.statusGraduacao.aulasRealizadasNestaFaixa,
          dataUltimaGraduacao: aluno.statusGraduacao.dataUltimaGraduacao,
        );
        elegivel = eleg.elegivel || eleg.prontoParaProximaFaixa;
      }

      if (elegivel) {
        alunosElegiveis.add(aluno.nome);
      }

      alunosReport.add(
        AlunoReportItem(
          alunoId: aluno.id,
          nome: aluno.nome,
          faixa: aluno.statusGraduacao.faixaAtual,
          grau: aluno.statusGraduacao.graus,
          presencas: presencas,
          frequenciaPercent: frequencia,
          elegivelGraduacao: elegivel,
        ),
      );
    }

    // Ordenar por frequência (maior primeiro)
    alunosReport.sort(
      (a, b) => b.frequenciaPercent.compareTo(a.frequenciaPercent),
    );

    return TurmaReport(
      turmaId: params.turmaId,
      nomeTurma: turma.nome,
      dataInicio: params.dataInicio,
      dataFim: params.dataFim,
      totalAulas: totalAulas,
      totalAlunos: alunos.length,
      mediaPresenca: alunos.isNotEmpty ? somaFrequencia / alunos.length : 0,
      alunos: alunosReport,
      alunosElegiveis: alunosElegiveis,
    );
  }
}
