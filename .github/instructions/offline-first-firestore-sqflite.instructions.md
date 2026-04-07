---
description: "Use when implementing or refactoring Offline-First flows in app/lib with local persistence (sqflite) and cloud sync (Cloud Firestore). Load skill offline-first-firestore-sqflite."
name: "Offline-First Firestore sqflite"
applyTo: "app/lib/**/*.dart"
---

# Offline-First Firestore sqflite

- Para qualquer tarefa Offline-First, iniciar pela skill offline-first-firestore-sqflite.
- Firestore ja esta configurado no projeto e deve continuar como fonte remota principal.
- Persistencia local com sqflite deve ser adicionada/evoluida de forma incremental.

## Diretrizes obrigatorias
- Fluxo de implementacao: source (local/remote) -> repository/usecase -> vm/command -> page.
- Escrita deve ser Local-First para features offline-first.
- Sincronizacao remota deve ser assincrona e idempotente.
- Presenter nao deve escrever diretamente no Firestore.

## Estrategia recomendada
- Introduzir Outbox para comandos pendentes de sync.
- Manter commandId para deduplicacao e idempotencia.
- Reprocessar pendencias com retry e backoff.
- Persistir projecoes locais necessarias para leitura rapida da UI.

## Qualidade e validacao
- Cobrir casos offline, reconexao, retry e deduplicacao em testes.
- Rodar flutter analyze e flutter test para a feature alterada.
