---
description: "Use when writing, updating or running Dart and Flutter tests for this project. Load skill flutter-feature-testing, follow official guidance, and enforce mock framework by layer for the current architecture (Provider + ChangeNotifier + Command)."
name: "Flutter Testing Convention"
applyTo: "app/test/**/*.dart, app/integration_test/**/*.dart"
---

# Flutter Testing Convention

This instruction is based on official guidance:
- Dart testing: https://dart.dev/tools/testing
- Flutter testing overview: https://docs.flutter.dev/testing
- Flutter unit tests cookbook: https://docs.flutter.dev/cookbook/testing/unit/introduction
- Flutter widget tests cookbook: https://docs.flutter.dev/cookbook/testing/widget/introduction
- Flutter integration tests cookbook: https://docs.flutter.dev/cookbook/testing/integration/introduction

## Workflow
- Iniciar o trabalho de testes pela skill flutter-feature-testing.

## Objetivos principais
- Testes deterministas, legiveis e focados em comportamento.
- Priorizar testes de unidade e widget.
- Usar integracao para jornadas criticas quando necessario.

## Organizacao
- Unit/widget tests em app/test.
- Integracao em app/integration_test.
- Nomes de arquivos terminando com _test.dart.

## Convencao de mocks por camada
- Source, repository e usecase: Mockito.
- Presenter (ViewModel/Command/widget): Mocktail.
- bloc_test somente se a feature realmente usar Bloc/Cubit.

## Praticas por tipo de teste
- Unidade:
  - Arrange/Act/Assert claro.
  - Cobrir sucesso e falha.
- Widget:
  - testWidgets com finders orientados ao comportamento visivel.
  - Validar estados de loading, sucesso, vazio e erro quando aplicavel.
- Presenter:
  - Validar transicoes de estado de ChangeNotifier e efeitos de Command.

## Assincrono e erros
- Sempre usar await em operacoes async.
- Evitar side effects escondidos e testes flaky.
- Verificar erros esperados com matchers especificos.

## Execucao antes de concluir
- Rodar testes focados da feature alterada.
- Rodar flutter analyze.
- Se necessario, rodar suite ampliada.

Comandos recomendados (dentro de app/):
- flutter analyze
- flutter test
- flutter test test/path/to/changed_test.dart
- flutter test integration_test
