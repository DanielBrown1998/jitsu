---
name: flutter-feature-development
description: "Use quando: codar ou refatorar feature Flutter no Jitsu. Segue arquitetura core/domain/infra/ui, fluxo source -> repository/usecase -> vm/command -> page/route/di, com Provider + ChangeNotifier + Command e integracao Firebase ja ativa."
argument-hint: "descreva a feature e o contexto"
user-invocable: true
---

# Desenvolvimento de Feature Flutter no Jitsu

## Objetivo
Implementar uma feature de ponta a ponta no padrao real do projeto, mantendo consistencia arquitetural, baixo acoplamento e qualidade de codigo.

## Arquitetura real do projeto
- Estrutura principal: app/lib/core, app/lib/domain, app/lib/infra e app/lib/ui.
- Infra/source: acesso tecnico (Firestore/Auth/storage e afins).
- Domain/repositories + domain/usecases: contratos e regras de negocio.
- UI: ViewModel + Command + pages + routes por feature.
- Estado no presenter: Provider + ChangeNotifier + Command.
- Injeccao principal em app/lib/core/di/injection.dart e app/lib/core/di/injection_widget.dart.
- Roteamento em app/lib/core/router/router.dart e app/lib/ui/**/route/route.dart.
- Firestore e Auth ja configurados em app/lib/core/firebase/instance.dart.

## Regras obrigatorias
1. Antes de codar, mapear o que ja existe para evitar duplicacao.
2. Implementar sempre nesta ordem: source -> repository/usecase -> vm/command -> page/route/di.
3. Se parte da etapa ja existir e estiver correta, pular para a proxima etapa.
4. Widgets personalizados:
   - sempre criar classes StatelessWidget ou StatefulWidget
   - nunca criar funcoes que retornam Widget
5. Seguir Clean Architecture:
   - presenter nao acessa source diretamente
   - usecase fala com repository abstrato
   - repository concreto fala com source
6. Aplicar SOLID e Clean Code:
   - classes pequenas e com responsabilidade unica
   - nomes claros e semanticos
   - evitar logica de negocio dentro da page
7. Criar testes de unidade e widget sempre que possivel.
8. Padrao de testes por camada:
  - source/repository/usecase: usar Mockito
  - presenter (vm/command/widget): usar Mocktail
  - bloc_test somente se a feature realmente usar Bloc/Cubit
9. Convencao de roteamento com go_router:
  - criar rota da feature em ui/<feature>/route/route.dart
  - exportar rota em ui/route.dart
  - registrar rota em core/router/router.dart
  - criar ShellRoute somente quando a feature precisar de wrapper proprio
10. Erros personalizados obrigatorios:
  - nunca usar `throw Exception(...)` generica para regra da feature
  - sempre criar ou atualizar classes de erro em app/lib/core/error/
  - organizar por contexto da feature quando necessario
  - source, repository, usecase e presenter devem reutilizar essas classes ao propagar falhas
11. Se a feature exigir escrita Local-First e sincronizacao em nuvem, iniciar tambem a skill offline-first-firestore-sqflite.
12. Se a feature exigir migracao de erro para result_dart, iniciar tambem a skill result-dart-migration.

## Passo a passo de implementacao
1. Descoberta da feature
- Ler estruturas similares da mesma area (feature irma) para manter padrao de naming e pastas.
- Definir responsabilidades de source, usecase, vm e command antes de codar.

2. Source (infra/source)
- Criar ou completar interface de source em app/lib/infra/source.
- Implementar source concreto com acesso tecnico (Firestore, Auth, storage, api).
- Manter validacoes tecnicas locais e erros tecnicos bem definidos.
- Criar/atualizar erros personalizados em app/lib/core/error/ quando surgir novo cenario de falha.
- Nao declarar exceptions locais na propria camada da feature; centralizar em core/error.
- Evitar Exception generica, preferindo classes de erro semanticas e nomeadas.

3. Repository e Usecase (domain + data)
- Criar/atualizar repository abstrato no domain.
- Criar/atualizar repository impl mapeando model <-> entity.
- Criar/atualizar usecase(s) no domain para orquestrar regra de negocio.
- Garantir que presenter depende apenas de usecase e entidades.

4. ViewModel e Command (ui/<feature>/logic)
- Criar/atualizar vm.dart extendendo ChangeNotifier quando aplicavel.
- Criar/atualizar command.dart para acionar casos de uso de forma rastreavel.
- Tratar sucesso/falha de forma explicita, evitando catch generico no presenter.

5. Page e widgets (ui/<feature>/page)
- Conectar page ao ViewModel/Command da feature.
- Extrair widgets reutilizaveis para classes proprias.
- Nao criar helper function retornando Widget.

6. Roteamento (go_router)
- Criar ou atualizar route.dart da feature em app/lib/ui/<feature>/route/route.dart.
- Exportar a rota em app/lib/ui/route.dart.
- Registrar no app/lib/core/router/router.dart.
- Criar ShellRoute apenas quando necessario.

7. Injecao de dependencias
- Registrar source, repository e usecase em app/lib/core/di/injection.dart quando aplicavel.
- Registrar vm da feature no ponto de DI apropriado (feature ou global).

8. Testes
- Unidade para source, repository e usecase quando possivel (Mockito).
- Presenter (vm/command/widget) com Mocktail.
- bloc_test somente se houver Bloc/Cubit de fato.
- Widget test para page principal e estados relevantes.

9. Validacao final
- Rodar flutter analyze.
- Rodar flutter test na feature alterada.
- Garantir que nao quebrou contratos existentes.

## Checklist de conclusao
- Fluxo implementado na ordem source -> repository/usecase -> vm/command -> page/route/di.
- Sem funcoes que retornam Widget em widgets personalizados.
- Todos os erros novos da feature estao em app/lib/core/error/ com classes personalizadas.
- Testes de unidade e widget criados sempre que possivel.
- Mockito aplicado em source/repository/usecase.
- Mocktail aplicado no presenter.
- Roteamento da feature registrado corretamente (incluindo export e router central).
- Testes executados com sucesso para os arquivos alterados.
- DI atualizada quando necessario.
