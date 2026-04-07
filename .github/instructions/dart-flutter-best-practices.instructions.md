---
description: "Use when writing or refactoring Dart and Flutter code in this project. Apply Effective Dart plus project architecture rules (core/domain/infra/ui, Provider + ChangeNotifier + Command, Firestore integration, and progressive result_dart migration)."
name: "Dart and Flutter Best Practices"
applyTo: "app/**/*.dart"
---

# Dart and Flutter Best Practices

This instruction is based on official guidance:
- Dart Effective Dart: https://dart.dev/effective-dart
- Dart lints: https://dart.dev/lints
- Flutter performance: https://docs.flutter.dev/perf/best-practices
- Flutter accessibility: https://docs.flutter.dev/ui/accessibility

## Vinculo com outras instructions
- Para implementacao/refatoracao de feature em app/lib, combinar com ./flutter-feature.instructions.md.
- Para testes em app/test e app/integration_test, combinar com ./flutter-testing.instructions.md.
- Para fluxos Offline-First, combinar com ./offline-first-firestore-sqflite.instructions.md.
- Para refatoracao de erro com result_dart, combinar com ./result-dart-migration.instructions.md.

## Contexto arquitetural do Jitsu
- Estrutura principal do app: core, domain, infra e ui.
- Estado no presenter: Provider + ChangeNotifier + Command.
- Nao assumir Bloc/Cubit como padrao atual.
- Firestore e Firebase Auth ja configurados, com acesso central em core/firebase/instance.dart.
- Injeccao de dependencias em core/di/injection.dart.

## Estilo Dart e design de API
- Usar convencoes do dart format.
- Naming:
  - Tipos: UpperCamelCase.
  - Demais identificadores: lowerCamelCase.
  - Arquivos e pastas: lowercase_with_underscores.
- Manter imports ordenados (dart:, package:, relativo).
- Preferir final e const quando possivel.
- Evitar dynamic sem necessidade.
- Evitar bool posicional; preferir named parameters.

## Null safety, async e erros
- Usar null safety de forma estrita.
- Preferir async/await para legibilidade.
- Evitar catch generico sem mapeamento semantico.
- Em migracao de result_dart:
  - Source tecnico pode lancar excecoes tipadas.
  - Repository concreto traduz erro tecnico para erro de dominio.
  - Usecase e VM consomem AsyncResult de forma explicita.

## UI, composicao e estado
- Manter build enxuto e sem trabalho pesado.
- Preferir classes de widget reutilizaveis em vez de funcoes que retornam Widget.
- Usar const constructors quando possivel.
- Em ViewModel/Command, manter estado observavel e previsivel.

## Firestore e acesso a dados
- Acesso direto a Firestore apenas na camada infra/source.
- Presenter nao acessa Firebase diretamente.
- Usecases devem depender de contratos de repository.

## Performance e acessibilidade
- Usar builders lazy para listas grandes.
- Evitar widgets/caminhos que causam custo desnecessario de render.
- Garantir alvos de toque >= 48x48.
- Garantir contraste adequado e Semantics para controles.

## Qualidade e validacao
- Corrigir lints introduzidos pela alteracao.
- Antes de concluir:
  - flutter analyze
  - flutter test (focado na feature alterada primeiro)
