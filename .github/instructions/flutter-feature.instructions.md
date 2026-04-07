---
description: "Use when implementing or refactoring Flutter features in app/lib. Load skill flutter-feature-development and enforce project flow source -> repository/usecase -> vm/command -> page/route/di, aligned with Provider + ChangeNotifier architecture."
name: "Flutter Feature Flow"
applyTo: "app/lib/**/*.dart"
---

# Flutter Feature Flow

- Iniciar o trabalho pela skill flutter-feature-development.
- Aplicar esta instruction junto com ./dart-flutter-best-practices.instructions.md.
- Para testes, aplicar tambem ./flutter-testing.instructions.md.
- Para fluxos Offline-First, aplicar tambem ./offline-first-firestore-sqflite.instructions.md.
- Para migracao de erro com result_dart, aplicar tambem ./result-dart-migration.instructions.md.

## Fluxo de implementacao
- Implementar na ordem: source -> repository/usecase -> vm/command -> page/route/di.
- Pular etapas que ja existem e estao corretas.
- Manter separacao entre infra, domain e ui.
- Evitar logica de negocio dentro da page.
- Nao criar funcoes que retornam Widget para widgets personalizados.

## Estado e presenter
- Padrao atual do projeto: ChangeNotifier + Command + Provider.
- Nao assumir Bloc/Cubit como padrao para novas features.
- Caso uma feature realmente exija Bloc/Cubit, justificar tecnicamente e isolar o uso.

## Dados e Firestore
- Firestore ja esta configurado no projeto.
- Acesso a Firestore deve ficar em infra/source.
- Presenter nao acessa Firestore diretamente.

## Roteamento (go_router)
- Criar/atualizar rota da feature em ui/<feature>/route/route.dart.
- Exportar a rota em ui/route.dart.
- Registrar a rota em core/router/router.dart.
- Criar ShellRoute somente quando houver necessidade real de wrapper de feature ou subfluxos.

## Injeccao de dependencia
- Registrar source/repository/usecase em core/di/injection.dart quando necessario.
- Registrar ViewModel da feature no arquivo de DI da propria feature ou no ponto central ja existente.

## Validacao final
- Rodar flutter analyze.
- Rodar flutter test focado na feature alterada.
- Reportar resultado da execucao.
