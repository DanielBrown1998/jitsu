# Projeto Jitsu - Instrucoes do Copilot

## Uso de Skills (obrigatorio)
- Se a tarefa for implementar ou refatorar feature Flutter em app/lib, usar a skill flutter-feature-development.
- Se a tarefa for criar, ajustar e executar testes da feature alterada, usar a skill flutter-feature-testing.
- Se a tarefa for implementar arquitetura Offline-First com persistencia local em sqflite e sincronizacao no Cloud Firestore, usar a skill offline-first-firestore-sqflite.
- Se a tarefa for migrar tratamento de erro para result_dart em features ja implementadas, usar a skill result-dart-migration.
- Se a tarefa for deploy, secrets, webhook ou validacao de Cloud Functions (quando houver codigo em functions/), usar a skill functions-deploy.

## Vinculo de Instructions (obrigatorio)
- .github/instructions/dart-flutter-best-practices.instructions.md: regras transversais de boas praticas Dart/Flutter para app/**/*.dart.
- .github/instructions/flutter-feature.instructions.md: fluxo de implementacao de feature para app/lib/**/*.dart.
- .github/instructions/flutter-testing.instructions.md: convencoes de testes para app/test/**/*.dart e app/integration_test/**/*.dart.
- .github/instructions/offline-first-firestore-sqflite.instructions.md: regras de Offline-First com sqflite + Firestore para app/lib/**/*.dart.
- .github/instructions/result-dart-migration.instructions.md: regras para refatoracao de fluxo de erro com result_dart em app/lib/**/*.dart.
- .github/instructions/functions-deploy.instructions.md: deploy e validacao de Cloud Functions.

## Arquitetura base do projeto (estado atual)
- Estrutura principal em app/lib: core, domain, infra e ui.
- Presenter padrao: Provider + ChangeNotifier + Command.
- Nao assumir Bloc/Cubit como padrao do projeto.
- Firestore e Auth ja estao configurados (core/firebase/instance.dart).
- Injecao principal em core/di/injection.dart e providers em core/di/injection_widget.dart.
- Roteamento com go_router em core/router/router.dart e ui/**/route/route.dart.

## Fluxo de implementacao de feature
- Seguir ordem: source -> repository/usecase -> vm/command -> page/route/di.
- Se uma etapa ja existir e estiver correta, pular para a proxima etapa.

## Convencoes de arquitetura
- Respeitar fronteiras entre infra, domain e ui.
- UI/presenter nao acessa source diretamente.
- Usecase depende de repository abstrato.
- Repository concreto depende de source.
- Acesso a Firestore concentrado na camada infra/source.

## Convencoes de UI e estado
- Ao criar widgets personalizados, nao criar funcoes que retornam Widget.
- Preferir classes StatelessWidget ou StatefulWidget.
- Para estado de tela, preferir ChangeNotifier + Command conforme padrao atual.

## Convencoes de roteamento (go_router)
- Registrar rotas da feature em ui/<feature>/route/route.dart.
- Exportar nova rota em ui/route.dart.
- Registrar rota em core/router/router.dart.
- Criar ShellRoute somente quando a feature precisar de wrapper proprio ou listeners compartilhados entre subrotas.

## Convencoes de testes
- Source, repository e usecase: Mockito.
- Presenter (vm/command/widget): Mocktail.
- bloc_test apenas se uma feature realmente usar Bloc/Cubit.
- Sempre que possivel, criar testes de unidade e widget para a feature alterada.

## Validacao final
- Rodar flutter analyze.
- Rodar flutter test focado nos arquivos da feature alterada.
- Reportar resultado da execucao dos testes.
