import 'package:result_dart/result_dart.dart';

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

class ExportDataException implements Exception {
  final String message;
  ExportDataException(this.message);

  @override
  String toString() => 'ExportDataException: $message';
}

abstract class ExportDataToCsvUseCase {
  AsyncResult<String> call(ExportDataParams params);
}

/// Use Case: Exportar Dados para CSV
class ExportDataToCsvUseCaseImpl implements ExportDataToCsvUseCase {
  final AlunoRepository _alunoRepository;
  final TurmaRepository _turmaRepository;
  final ReportRepository _reportRepository;

  ExportDataToCsvUseCaseImpl(
    this._alunoRepository,
    this._turmaRepository,
    this._reportRepository,
  );

  @override
  AsyncResult<String> call(ExportDataParams params) async {
    try {
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
    } on ExportDataException catch (e) {
      return Failure(e);
    } catch (e) {
      return Failure(
        ExportDataException('Erro inesperado ao exportar dados: $e'),
      );
    }
  }

  AsyncResult<String> _exportAlunos(String? turmaId) async {
    try {
      final buffer = StringBuffer();

      // Header
      buffer.writeln(
        'ID,Nome,Faixa,Grau,Aulas Realizadas,Data Última Graduação,Ativo',
      );

      List<Aluno> alunos;
      if (turmaId != null) {
        final alunosResult = await _reportRepository.getAlunosByTurma(turmaId);
        alunos = alunosResult.fold(
          (a) => a,
          (e) => throw ExportDataException('Erro ao buscar alunos: $e'),
        );
      } else {
        final alunosResult = await _reportRepository.getAllAlunos();
        alunos = alunosResult.fold(
          (a) => a,
          (e) => throw ExportDataException('Erro ao buscar todos alunos: $e'),
        );
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

      return Success(buffer.toString());
    } on ExportDataException catch (e) {
      return Failure(e);
    }
  }

  AsyncResult<String> _exportTurmas() async {
    try {
      final buffer = StringBuffer();

      // Header
      buffer.writeln('ID,Nome,Professor ID,Horário Padrão');

      final turmasResult = await _turmaRepository.getAll();
      final turmas = turmasResult.fold(
        (t) => t,
        (e) => throw ExportDataException('Erro ao buscar turmas: $e'),
      );

      for (final turma in turmas) {
        buffer.writeln(
          '${turma.id},'
          '${_escapeCsv(turma.nome)},'
          '${turma.professorId},'
          '${turma.horarioPadrao}',
        );
      }

      return Success(buffer.toString());
    } on ExportDataException catch (e) {
      return Failure(e);
    }
  }

  AsyncResult<String> _exportPresencas(ExportDataParams params) async {
    try {
      final buffer = StringBuffer();

      // Header
      buffer.writeln('Aluno ID,Nome,Turma,Presenças,Frequência %');

      if (params.turmaId == null ||
          params.dataInicio == null ||
          params.dataFim == null) {
        return Failure(
          ExportDataException(
            'turmaId, dataInicio e dataFim são obrigatórios para exportar presenças',
          ),
        );
      }

      final alunosResult = await _reportRepository.getAlunosByTurma(
        params.turmaId!,
      );
      final alunos = alunosResult.fold(
        (a) => a,
        (e) => throw ExportDataException('Erro ao buscar alunos: $e'),
      );

      final totalAulasResult = await _reportRepository.contarAulasPorTurma(
        params.turmaId!,
        params.dataInicio!,
        params.dataFim!,
      );
      final totalAulas = totalAulasResult.fold(
        (a) => a,
        (e) => throw ExportDataException('Erro ao contar aulas: $e'),
      );

      final turmasResult = await _turmaRepository.getByIds([params.turmaId!]);
      final turmas = turmasResult.fold(
        (t) => t,
        (e) => throw ExportDataException('Erro ao buscar turma: $e'),
      );
      final nomeTurma = turmas.isNotEmpty ? turmas.first.nome : params.turmaId!;

      for (final aluno in alunos) {
        final presencasResult = await _reportRepository.contarPresencasAluno(
          aluno.id,
          params.turmaId!,
          params.dataInicio!,
          params.dataFim!,
        );
        final presencas = presencasResult.fold(
          (p) => p,
          (e) => throw ExportDataException(
            'Erro ao contar presenças de ${aluno.id}: $e',
          ),
        );
        final frequencia = totalAulas > 0
            ? (presencas / totalAulas) * 100
            : 0.0;

        buffer.writeln(
          '${aluno.id},'
          '${_escapeCsv(aluno.nome)},'
          '${_escapeCsv(nomeTurma)},'
          '$presencas,'
          '${frequencia.toStringAsFixed(1)}',
        );
      }

      return Success(buffer.toString());
    } on ExportDataException catch (e) {
      return Failure(e);
    }
  }

  AsyncResult<String> _exportGraduacoes(String? turmaId) async {
    try {
      final buffer = StringBuffer();

      // Header
      buffer.writeln(
        'Aluno ID,Nome,Faixa Anterior,Grau Anterior,Faixa Nova,Grau Novo,Data,Observação',
      );

      List<Aluno> alunos;
      if (turmaId != null) {
        final alunosResult = await _reportRepository.getAlunosByTurma(turmaId);
        alunos = alunosResult.fold(
          (a) => a,
          (e) => throw ExportDataException('Erro ao buscar alunos: $e'),
        );
      } else {
        final alunosResult = await _reportRepository.getAllAlunos();
        alunos = alunosResult.fold(
          (a) => a,
          (e) => throw ExportDataException('Erro ao buscar todos alunos: $e'),
        );
      }

      for (final aluno in alunos) {
        final historicoResult = await _alunoRepository.getHistorico(aluno.id);
        final historico = historicoResult.fold(
          (h) => h,
          (e) => throw ExportDataException(
            'Erro ao buscar histórico de ${aluno.id}: $e',
          ),
        );

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

      return Success(buffer.toString());
    } on ExportDataException catch (e) {
      return Failure(e);
    }
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
