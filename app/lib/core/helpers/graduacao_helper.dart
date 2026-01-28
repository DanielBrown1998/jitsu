/// Critérios de graduação CBJJ/IBJJF para Jiu-Jitsu
library;

enum Faixa {
  branca,
  azul,
  roxa,
  marrom,
  preta,
  coralPretaVermelha, // 7° grau
  coralVermelhabranca, // 8° grau
  vermelha, // 9° e 10° grau
}

class CriterioGraduacao {
  final Faixa faixa;
  final int grausMaximos;
  final int aulasMinPorGrau;
  final int mesesMinPorGrau;
  final int mesesMinParaProximaFaixa;
  final int idadeMinima;
  final Faixa? proximaFaixa;

  const CriterioGraduacao({
    required this.faixa,
    required this.grausMaximos,
    required this.aulasMinPorGrau,
    required this.mesesMinPorGrau,
    required this.mesesMinParaProximaFaixa,
    required this.idadeMinima,
    this.proximaFaixa,
  });
}

class GraduacaoHelper {
  /// Critérios oficiais por faixa
  static const Map<Faixa, CriterioGraduacao> criterios = {
    Faixa.branca: CriterioGraduacao(
      faixa: Faixa.branca,
      grausMaximos: 4,
      aulasMinPorGrau: 40,
      mesesMinPorGrau: 4,
      mesesMinParaProximaFaixa: 0, // Sem tempo mínimo para azul
      idadeMinima: 16,
      proximaFaixa: Faixa.azul,
    ),
    Faixa.azul: CriterioGraduacao(
      faixa: Faixa.azul,
      grausMaximos: 4,
      aulasMinPorGrau: 50,
      mesesMinPorGrau: 6,
      mesesMinParaProximaFaixa: 24, // 2 anos mínimo
      idadeMinima: 16,
      proximaFaixa: Faixa.roxa,
    ),
    Faixa.roxa: CriterioGraduacao(
      faixa: Faixa.roxa,
      grausMaximos: 4,
      aulasMinPorGrau: 50,
      mesesMinPorGrau: 5,
      mesesMinParaProximaFaixa: 18, // 1.5 anos mínimo
      idadeMinima: 16,
      proximaFaixa: Faixa.marrom,
    ),
    Faixa.marrom: CriterioGraduacao(
      faixa: Faixa.marrom,
      grausMaximos: 4,
      aulasMinPorGrau: 50,
      mesesMinPorGrau: 4,
      mesesMinParaProximaFaixa: 12, // 1 ano mínimo
      idadeMinima: 18,
      proximaFaixa: Faixa.preta,
    ),
    Faixa.preta: CriterioGraduacao(
      faixa: Faixa.preta,
      grausMaximos: 6,
      aulasMinPorGrau: 0, // Baseado em tempo
      mesesMinPorGrau: 36, // 3 anos por grau
      mesesMinParaProximaFaixa: 252, // 7 anos para coral (7° grau)
      idadeMinima: 19,
      proximaFaixa: Faixa.coralPretaVermelha,
    ),
    Faixa.coralPretaVermelha: CriterioGraduacao(
      faixa: Faixa.coralPretaVermelha,
      grausMaximos: 0,
      aulasMinPorGrau: 0,
      mesesMinPorGrau: 84, // 7 anos
      mesesMinParaProximaFaixa: 84,
      idadeMinima: 50,
      proximaFaixa: Faixa.coralVermelhabranca,
    ),
    Faixa.coralVermelhabranca: CriterioGraduacao(
      faixa: Faixa.coralVermelhabranca,
      grausMaximos: 0,
      aulasMinPorGrau: 0,
      mesesMinPorGrau: 120, // 10 anos
      mesesMinParaProximaFaixa: 120,
      idadeMinima: 57,
      proximaFaixa: Faixa.vermelha,
    ),
    Faixa.vermelha: CriterioGraduacao(
      faixa: Faixa.vermelha,
      grausMaximos: 1, // 9° e 10° grau
      aulasMinPorGrau: 0,
      mesesMinPorGrau: 120,
      mesesMinParaProximaFaixa: 0, // Última faixa
      idadeMinima: 67,
      proximaFaixa: null,
    ),
  };

  /// Nomes das faixas em português
  static const Map<Faixa, String> nomesFaixas = {
    Faixa.branca: 'Branca',
    Faixa.azul: 'Azul',
    Faixa.roxa: 'Roxa',
    Faixa.marrom: 'Marrom',
    Faixa.preta: 'Preta',
    Faixa.coralPretaVermelha: 'Coral Preta/Vermelha',
    Faixa.coralVermelhabranca: 'Coral Vermelha/Branca',
    Faixa.vermelha: 'Vermelha',
  };

  /// Converte string para enum Faixa
  static Faixa? faixaFromString(String nome) {
    final nomeLower = nome.toLowerCase();
    for (final entry in nomesFaixas.entries) {
      if (entry.value.toLowerCase() == nomeLower) {
        return entry.key;
      }
    }
    return null;
  }

  /// Obtém nome da faixa
  static String getNomeFaixa(Faixa faixa) => nomesFaixas[faixa] ?? '';

  /// Obtém critério por faixa
  static CriterioGraduacao? getCriterio(Faixa faixa) => criterios[faixa];

  /// Verifica se pode receber próximo grau
  static ElegibilidadeGrau verificarElegibilidadeGrau({
    required Faixa faixaAtual,
    required int grauAtual,
    required int aulasRealizadas,
    required DateTime dataUltimaGraduacao,
  }) {
    final criterio = criterios[faixaAtual];
    if (criterio == null) {
      return ElegibilidadeGrau(elegivel: false, motivo: 'Faixa inválida');
    }

    // Já está no grau máximo
    if (grauAtual >= criterio.grausMaximos) {
      return ElegibilidadeGrau(
        elegivel: false,
        motivo: 'Grau máximo atingido. Elegível para próxima faixa.',
        prontoParaProximaFaixa: true,
      );
    }

    final mesesDesdeUltimaGraduacao = _calcularMeses(
      dataUltimaGraduacao,
      DateTime.now(),
    );
    final aulasParaProximoGrau = criterio.aulasMinPorGrau;

    // Verifica tempo mínimo
    if (mesesDesdeUltimaGraduacao < criterio.mesesMinPorGrau) {
      final mesesRestantes =
          criterio.mesesMinPorGrau - mesesDesdeUltimaGraduacao;
      return ElegibilidadeGrau(
        elegivel: false,
        motivo: 'Faltam $mesesRestantes meses para próximo grau',
        mesesRestantes: mesesRestantes,
        aulasRestantes: aulasParaProximoGrau > aulasRealizadas
            ? aulasParaProximoGrau - aulasRealizadas
            : 0,
      );
    }

    // Verifica aulas mínimas
    if (aulasRealizadas < aulasParaProximoGrau) {
      final aulasRestantes = aulasParaProximoGrau - aulasRealizadas;
      return ElegibilidadeGrau(
        elegivel: false,
        motivo: 'Faltam $aulasRestantes aulas para próximo grau',
        aulasRestantes: aulasRestantes,
      );
    }

    return ElegibilidadeGrau(
      elegivel: true,
      motivo: 'Elegível para o ${grauAtual + 1}° grau!',
    );
  }

  /// Verifica se pode receber próxima faixa
  static ElegibilidadeFaixa verificarElegibilidadeFaixa({
    required Faixa faixaAtual,
    required int grauAtual,
    required DateTime dataUltimaGraduacao,
    required int idadeAluno,
  }) {
    final criterio = criterios[faixaAtual];
    if (criterio == null) {
      return ElegibilidadeFaixa(elegivel: false, motivo: 'Faixa inválida');
    }

    if (criterio.proximaFaixa == null) {
      return ElegibilidadeFaixa(
        elegivel: false,
        motivo: 'Já está na faixa máxima',
      );
    }

    // Precisa ter todos os graus
    if (grauAtual < criterio.grausMaximos) {
      return ElegibilidadeFaixa(
        elegivel: false,
        motivo: 'Precisa completar o ${criterio.grausMaximos}° grau',
        grausRestantes: criterio.grausMaximos - grauAtual,
      );
    }

    final proximaFaixaCriterio = criterios[criterio.proximaFaixa!]!;

    // Verifica idade mínima
    if (idadeAluno < proximaFaixaCriterio.idadeMinima) {
      return ElegibilidadeFaixa(
        elegivel: false,
        motivo: 'Idade mínima: ${proximaFaixaCriterio.idadeMinima} anos',
      );
    }

    // Verifica tempo mínimo na faixa
    final mesesNaFaixa = _calcularMeses(dataUltimaGraduacao, DateTime.now());
    if (mesesNaFaixa < criterio.mesesMinParaProximaFaixa) {
      final mesesRestantes = criterio.mesesMinParaProximaFaixa - mesesNaFaixa;
      return ElegibilidadeFaixa(
        elegivel: false,
        motivo:
            'Faltam $mesesRestantes meses para ${getNomeFaixa(criterio.proximaFaixa!)}',
        mesesRestantes: mesesRestantes,
      );
    }

    return ElegibilidadeFaixa(
      elegivel: true,
      motivo: 'Elegível para faixa ${getNomeFaixa(criterio.proximaFaixa!)}!',
      proximaFaixa: criterio.proximaFaixa,
    );
  }

  /// Calcula progresso percentual para próximo grau
  static double calcularProgressoGrau({
    required Faixa faixaAtual,
    required int aulasRealizadas,
    required DateTime dataUltimaGraduacao,
  }) {
    final criterio = criterios[faixaAtual];
    if (criterio == null || criterio.aulasMinPorGrau == 0) return 0;

    final progressoAulas = (aulasRealizadas / criterio.aulasMinPorGrau).clamp(
      0.0,
      1.0,
    );
    final meses = _calcularMeses(dataUltimaGraduacao, DateTime.now());
    final progressoTempo = (meses / criterio.mesesMinPorGrau).clamp(0.0, 1.0);

    // Média entre progresso de aulas e tempo
    return ((progressoAulas + progressoTempo) / 2 * 100);
  }

  static int _calcularMeses(DateTime inicio, DateTime fim) {
    return (fim.year - inicio.year) * 12 + fim.month - inicio.month;
  }
}

/// Resultado da verificação de elegibilidade para grau
class ElegibilidadeGrau {
  final bool elegivel;
  final String motivo;
  final int aulasRestantes;
  final int mesesRestantes;
  final bool prontoParaProximaFaixa;

  ElegibilidadeGrau({
    required this.elegivel,
    required this.motivo,
    this.aulasRestantes = 0,
    this.mesesRestantes = 0,
    this.prontoParaProximaFaixa = false,
  });
}

/// Resultado da verificação de elegibilidade para faixa
class ElegibilidadeFaixa {
  final bool elegivel;
  final String motivo;
  final int grausRestantes;
  final int mesesRestantes;
  final Faixa? proximaFaixa;

  ElegibilidadeFaixa({
    required this.elegivel,
    required this.motivo,
    this.grausRestantes = 0,
    this.mesesRestantes = 0,
    this.proximaFaixa,
  });
}
