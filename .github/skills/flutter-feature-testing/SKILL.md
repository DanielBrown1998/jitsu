---
name: flutter-feature-testing
description: "Use quando: apos implementar/refatorar feature Flutter no Jitsu, criar e executar testes com Mockito em source/repository/usecase e Mocktail em ViewModel/Command/widget, seguindo arquitetura Provider + ChangeNotifier."
argument-hint: "descreva a feature alterada e os arquivos impactados"
user-invocable: true
---

# Testes de Feature Flutter

## Objetivo
Garantir que toda feature implementada tenha cobertura minima de unidade e widget, com execucao real dos testes antes de concluir a tarefa.

## Escopo padrao
- Unidade:
  - source, repository e usecase (com Mockito)
  - ViewModel/Command no presenter (com Mocktail)
- Widget:
  - page principal da feature (com Mocktail quando precisar de mock)
  - widgets criticos de estado (loading, success, empty, error)
- Integracao (quando necessario):
  - fluxos criticos end-to-end em app/integration_test

## Regras obrigatorias
1. Sempre criar testes para a feature que acabou de ser implementada/modificada.
2. Usar Mockito em testes de source, repository e usecase.
3. Usar Mocktail no presenter (vm/command/widget).
4. Usar bloc_test somente se a feature realmente usar Bloc/Cubit.
5. Executar os testes criados no final e reportar resultado.

## Procedimento
1. Mapear alteracoes da feature
- Levantar arquivos alterados em infra/domain/ui.
- Derivar lista de testes necessarios por camada.

2. Criar testes de unidade
- Source/repository/usecase (Mockito):
  - garantir caminho de sucesso
  - garantir falhas relevantes
- ViewModel/Command no presenter (Mocktail):
  - testar estado inicial
  - testar transicoes de estado apos sucesso e erro
  - validar efeitos de notifyListeners e comandos quando aplicavel

3. Criar testes de widget
- Renderizacao da page com providers necessarios.
- Interacoes principais (tap, submit, navegacao quando aplicavel).
- Estados criticos (ex.: vazio, loading, erro).

4. Rodar testes
- Executar testes focados da feature primeiro.
- Se necessario, executar suite ampliada.

5. Entregar relatorio
- Quais arquivos de teste foram criados/atualizados.
- Resultado da execucao (pass/fail).
- Pontos que nao puderam ser cobertos e motivo.

## Comandos recomendados
Executar dentro de app/:
- flutter test
- flutter test test/path/to/changed_test.dart
- flutter test integration_test

Observacao:
- Preferir execucao focada nos testes da feature para feedback rapido.
- Rodar flutter analyze antes de concluir.

## Padroes de qualidade para novos testes
- Arrange/Act/Assert explicito.
- Nomes de testes descritivos e em linguagem de comportamento.
- Sem dependencia de ordem entre testes.
- Sem flaky tests (evitar dependencias de tempo sem controle).

## Checklist de conclusao
- Testes de unidade criados para a feature quando possivel.
- Testes de widget criados para a feature quando possivel.
- Mockito aplicado em source/repository/usecase.
- Mocktail aplicado no presenter.
- bloc_test aplicado apenas se houver Bloc/Cubit.
- Testes executados e status reportado.
