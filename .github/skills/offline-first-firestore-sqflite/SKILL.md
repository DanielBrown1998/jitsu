---
name: offline-first-firestore-sqflite
description: "Use quando: implementar ou refatorar fluxo Offline-First no Jitsu com escrita Local-First, persistencia em sqflite e sincronizacao idempotente no Cloud Firestore."
argument-hint: "descreva a feature e o fluxo alvo para aplicar command + outbox + sync"
user-invocable: true
---

# Offline-First com sqflite + Cloud Firestore

## Objetivo
Implementar escrita Local-First com sincronizacao assincrona em nuvem, sem acoplar UI a rede, preservando a arquitetura core/domain/infra/ui.

## Escopo desta skill
- Persistencia local com sqflite para leitura e escrita imediata.
- Encapsulamento de intencao de acao via Command Pattern de dominio + Outbox.
- Registro de comandos em Outbox para sincronizacao posterior.
- Sincronizacao com Cloud Firestore quando houver conectividade.
- Projecoes locais para leitura rapida e resiliente.

## Contexto atual do Jitsu
- Firestore ja esta configurado e em uso na camada infra/source.
- Pastas base para evolucao local ja existem (ex.: app/lib/core/sqlite), mas ainda sem implementacao completa.
- Estado da UI usa Provider + ChangeNotifier + Command.
- Nao assumir Bloc/Cubit como padrao.

## Regras obrigatorias
1. Seguir ordem de implementacao: source (local/remote) -> repository/usecase -> vm/command -> page.
2. Nao fazer escrita remota diretamente no presenter.
3. Toda acao mutavel do usuario deve virar Command serializavel de dominio.
4. Toda mutacao local deve ocorrer em transacao atomica junto com insert na Outbox.
5. Firestore e sqflite devem ser idempotentes por commandId.
6. Nao perder estado ao reiniciar app (outbox e projecoes devem sobreviver).
7. Distinguir Command de dominio (sincronizavel) de Command de UI (classe de presenter).

## Arquitetura alvo

### Local (sqflite)
- Tabela outbox_command:
  - id TEXT PRIMARY KEY
  - type TEXT NOT NULL
  - payload_json TEXT NOT NULL
  - status TEXT NOT NULL (pending, syncing, synced, failed)
  - retry_count INTEGER NOT NULL DEFAULT 0
  - created_at TEXT NOT NULL
  - updated_at TEXT NOT NULL
  - last_error TEXT NULL
  - next_retry_at TEXT NULL
- Tabelas de projecao local por feature:
  - exemplo: turma_projection, aluno_projection, presenca_projection
  - incluir source_command_id para rastreabilidade quando fizer sentido

### Nuvem (Cloud Firestore)
- Colecoes ja usadas no projeto devem ser preservadas e evoluidas (ex.: alunos, turmas, aulas_realizadas, historicos_*).
- Para idempotencia, usar commandId como chave de documento ou campo unico de deduplicacao.

Observacao:
- Use commandId como ID de documento no Firestore para idempotencia natural.
- Use serverTimestamp para auditoria remota.

## Tipos de comando recomendados
- register_attendance
- create_aluno
- update_aluno
- promote_aluno
- update_historico

Cada comando deve conter:
- id
- type
- createdAt
- actorId (uid)
- payload serializavel

## Fluxo padrao de execucao
1. Presenter dispara usecase ExecuteCommandUseCase.
2. Usecase valida comando e delega para repository.
3. Repository executa transacao local:
   - aplica mutacao local (projecao/tabela de leitura)
   - persiste comando em outbox_command com status pending
4. UI reflete estado local imediatamente.
5. SyncWorker processa outbox quando online:
   - marca syncing
   - envia para Firestore
   - marca synced em sucesso
   - marca failed e agenda retry com backoff em falha

## Fluxos prioritarios para Jitsu

### Presenca
- Registro de presenca deve atualizar leitura local imediatamente.
- Persistir comando pendente para sincronizacao futura no Firestore.

### Alunos e graduacao
- Alteracoes de cadastro e promocao devem ser aplicadas localmente e sincronizadas por outbox.
- Historicos devem manter rastreabilidade por commandId.

### Relatorios e dashboard
- Leituras da UI devem preferir projecoes locais quando o requisito for offline.
- Sincronizacao posterior deve reconciliar dados remotos sem duplicar eventos.

## Politica de conflito
- Firestore: idempotencia por commandId (upsert com mesmo ID).
- Ordem de sincronizacao: FIFO por created_at.
- Retry: backoff exponencial com limite de tentativas.
- Se comando irreconciliavel: manter failed com last_error e expor para observabilidade.

## Conectividade e gatilhos de sync
- Inicializar sync no bootstrap da aplicacao.
- Reagir ao retorno de conectividade.
- Reexecutar sync ao voltar para foreground.
- Evitar sync concorrente (lock/mutex no worker).

## Integracao com camadas

### Infra/source
- Criar source local para outbox e projecoes por feature.
- Criar source remoto para Firestore.
- Nao acessar Firestore do presenter.

### Domain/repository/usecase
- Repository abstrato para comando/sync/projecoes.
- Usecases minimos:
  - execute_command_usecase
  - sync_pending_commands_usecase
  - get_projection_usecase (por feature)

### Presenter (ViewModel/Command)
- ViewModels apenas disparam usecases e publicam estados.
- Commands de UI orquestram a acao, mas nao substituem outbox de dominio.
- Sem regras de persistencia/sync dentro da page.

## Testes obrigatorios
- Source/repository/usecase: Mockito.
- Presenter (vm/command/widget): Mocktail.
- bloc_test apenas se a feature realmente usar Bloc/Cubit.

Cenarios minimos:
- comando aplicado offline atualiza UI local
- comando persistido em outbox
- sync marca synced em sucesso
- sync marca failed com retry em falha
- reprocessamento nao duplica no Firestore
- projecoes persistem apos reinicio do app

## Qualidade e seguranca
- Nao expor dados sensiveis em payload de comando.
- Nao logar conteudo sensivel.
- Firestore rules devem restringir acesso por uid.

## Checklist de conclusao
- Escrita Local-First implementada.
- Outbox persistente e reprocessavel.
- Sync Firestore idempotente.
- Projecoes locais persistidas para leitura offline.
- Fluxo source -> repository/usecase -> vm/command -> page respeitado.
- flutter analyze e flutter test executados e reportados.
