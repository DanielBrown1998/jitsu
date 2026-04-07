---
description: "Use when migrating feature error flow to result_dart in app/lib. Load skill result-dart-migration and apply incremental refactor by feature."
name: "Result Dart Migration"
applyTo: "app/lib/**/*.dart"
---

# Result Dart Migration

- Para migracao de tratamento de erro, iniciar pela skill result-dart-migration.
- Migrar por feature, sem big-bang.

## Alvo arquitetural
- Contrato de repository no dominio deve retornar AsyncResult<Success, FailureDeDominio>.
- Source tecnico deve focar em acesso tecnico e pode lancar excecoes tipadas.
- Repository concreto traduz excecoes tecnicas para falhas de dominio.
- Usecase nao deve capturar erro tecnico de infra.
- ViewModel/Command deve consumir resultado com fold/map.

## Ordem recomendada por feature
1. Definir/ajustar falhas de dominio.
2. Atualizar contratos de repository no dominio.
3. Refatorar source/repository concreto para traducao de erros.
4. Atualizar usecases para fluxo limpo com AsyncResult.
5. Atualizar ViewModel/Command e telas.
6. Atualizar testes da feature na mesma entrega.

## Regras de migracao
- Evitar Failure(Exception(...)) generica.
- Evitar mistura desordenada de throw e Result no mesmo fluxo.
- Preservar comportamento funcional da feature durante a migracao.

