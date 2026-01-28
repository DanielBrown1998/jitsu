import '../../entities/aluno.dart';
import '../../repositories/aluno/i_aluno_repository.dart';
import '../../repositories/report/i_report_repository.dart';
import '../../repositories/turma/i_turma_repository.dart';

enum ExportType { alunos, turmas, presencas, graduacoes }

class ExportDataParams {
  final ExportType tipo;
  final String? turmaId;
  final DateTime? dataInicio;
  final DateTime? dataFim;

  ExportDataParams({
    required this.tipo,
    this.turmaId,
    this.dataInicio,
    this.dataFim,
  });
}

abstract class IExportDataToCsvUseCase {
  Future<String> call(ExportDataParams params);
}

/// Use Case: Exportar Dados para CSV
class ExportDataToCsvUseCase implements IExportDataToCsvUseCase {
  final IAlunoRepository _alunoRepository;
  final ITurmaRepository _turmaRepository;
  final IReportRepository _reportRepository;

  ExportDataToCsvUseCase(
    this._alunoRepository,
    this._turmaRepository,
    this._reportRepository,
  );

  @override
  Future<String> call(ExportDataParams params) async {
    switch (params.tipo) {
      case ExportType.alunos:
        return await _exportAlunos(params.turmaId);
      case ExportType.turmas:
        return await _exportTurmas();
      case ExportType.presencas:
        return await _exportPresencas(params);
      case ExportType.graduacoes:
        return await _exportGraduacoes(params.turmaId);
    }
  }

  Future<String> _exportAlunos(String? turmaId) async {
    final buffer = StringBuffer();

    // Header
    buffer.writeln(
      'ID,Nome,Faixa,Grau,Aulas Realizadas,Data Última Graduação,Ativo',
    );

    List<Aluno> alunos;
    if (turmaId != null) {
      alunos = await _reportRepository.getAlunosByTurma(turmaId);
    } else {
      // TODO: Implementar getAll no repository
      alunos = await _reportRepository.getAllAlunos();
    }

    for (final aluno in alunos) {
      buffer.writeln(
        '${aluno.id},'
        '${_escapeCsv(aluno.nome)},'
        '${aluno.statusGraduacao.faixaAtual},'
        '${aluno.statusGraduacao.graus},'
        '${aluno.statusGraduacao.aulasRealizadasNestaFaixa},'
        '${_formatDate(aluno.statusGraduacao.dataUltimaGraduacao)},'
        '${aluno.isAtivo ? "Sim" : "Não"}',
      );
    }

    return buffer.toString();
  }

  Future<String> _exportTurmas() async {
    final buffer = StringBuffer();

    // Header
    buffer.writeln('ID,Nome,Professor ID,Horário Padrão');

    final turmas = await _turmaRepository.getAll();

    for (final turma in turmas) {
      buffer.writeln(
        '${turma.id},'
        '${_escapeCsv(turma.nome)},'
        '${turma.professorId},'
        '${turma.horarioPadrao}',
      );
    }

    return buffer.toString();
  }

  Future<String> _exportPresencas(ExportDataParams params) async {
    final buffer = StringBuffer();

    // Header
    buffer.writeln('Aluno ID,Nome,Turma,Presenças,Frequência %');

    if (params.turmaId == null ||
        params.dataInicio == null ||
        params.dataFim == null) {
      throw ArgumentError(
        'turmaId, dataInicio e dataFim são obrigatórios para exportar presenças',
      );
    }

    final alunos = await _reportRepository.getAlunosByTurma(params.turmaId!);
    final totalAulas = await _reportRepository.contarAulasPorTurma(
      params.turmaId!,
      params.dataInicio!,
      params.dataFim!,
    );

    final turmas = await _turmaRepository.getByIds([params.turmaId!]);
    final nomeTurma = turmas.isNotEmpty ? turmas.first.nome : params.turmaId!;

    for (final aluno in alunos) {
      final presencas = await _reportRepository.contarPresencasAluno(
        aluno.id,
        params.turmaId!,
        params.dataInicio!,
        params.dataFim!,
      );
      final frequencia = totalAulas > 0 ? (presencas / totalAulas) * 100 : 0.0;

      buffer.writeln(
        '${aluno.id},'
        '${_escapeCsv(aluno.nome)},'
        '${_escapeCsv(nomeTurma)},'
        '$presencas,'
        '${frequencia.toStringAsFixed(1)}',
      );
    }

    return buffer.toString();
  }

  Future<String> _exportGraduacoes(String? turmaId) async {
    final buffer = StringBuffer();

    // Header
    buffer.writeln(
      'Aluno ID,Nome,Faixa Anterior,Grau Anterior,Faixa Nova,Grau Novo,Data,Observação',
    );

    List<Aluno> alunos;
    if (turmaId != null) {
      alunos = await _reportRepository.getAlunosByTurma(turmaId);
    } else {
      alunos = await _reportRepository.getAllAlunos();
    }

    for (final aluno in alunos) {
      final historico = await _alunoRepository.getHistorico(aluno.id);

      for (final h in historico) {
        buffer.writeln(
          '${aluno.id},'
          '${_escapeCsv(aluno.nome)},'
          '${h.faixaAnterior},'
          '${h.grauAnterior},'
          '${h.faixaNova},'
          '${h.grauNovo},'
          '${_formatDate(h.data)},'
          '${_escapeCsv(h.observacao ?? "")}',
        );
      }
    }

    return buffer.toString();
  }

  String _escapeCsv(String value) {
    if (value.contains(',') || value.contains('"') || value.contains('\n')) {
      return '"${value.replaceAll('"', '""')}"';
    }
    return value;
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/'
        '${date.year}';
  }
}
