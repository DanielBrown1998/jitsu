---
name: result-dart-migration
description: "Use quando: migrar feature Flutter ja implementada no Jitsu para fluxo de erro consistente com result_dart, contrato no dominio e traducao tecnica no repository concreto."
argument-hint: "informe feature alvo, entidade de sucesso e tipos de falha de dominio"
user-invocable: true
---

# Migracao para result_dart com Repositorio como ACL

## Objetivo
Trocar fluxo de erro inconsistente por sucesso/falha explicitos com result_dart, mantendo Clean Architecture e usando repository como fronteira anticorrupcao.

## Contexto atual no Jitsu
- O projeto ja usa result_dart em varios pontos, mas ainda com inconsistencias entre camadas.
- Em partes do codigo, source tecnico retorna AsyncResult diretamente.
- Em varias features, erros ainda chegam como Exception generica ou string.
- A migracao deve ser incremental por feature, sem quebrar o app.

## Regra de ouro (obrigatoria)
- Source/infra e tecnico: pode lancar excecoes tipadas.
- Contrato de Result nasce no dominio (interface do repository).
- Repository concreto captura erro tecnico e traduz para falha de dominio.
- Usecase nao conhece erro tecnico de sdk/rede/db.
- Presenter (ViewModel/Command) consome AsyncResult e decide estado por fold/map.

## Definicoes arquiteturais obrigatorias

### 1) Datasource (camada de dados, "suja")
- Lida com firebase, sqflite, parser JSON e SDKs externos.
- Pode lancar excecoes tecnicas (FirebaseException, SocketException, TimeoutException, FormatException).
- No alvo final da migracao, nao retorna Result de dominio.

### 2) Repositorio (fronteira / Anti-Corruption Layer)
- Traduz Data para Dominio.
- Converte Model/DTO em Entity de dominio no caminho de sucesso.
- Converte excecao tecnica em falha de dominio no caminho de erro.
- Implementa contrato do Dominio com AsyncResult<Sucesso, Falha>.

### 3) UseCase (dominio limpo)
- Recebe e devolve AsyncResult.
- Nao possui try/catch tecnico de infraestrutura.
- Faz apenas orquestracao de regra de negocio.
- Pode retornar Failure precoce para validacao de regra de dominio.

### 4) Apresentacao (ViewModel/Command)
- Consome AsyncResult com fold/map.
- Emite estado com base em falha tipada.
- Evita catch generico e mensagens soltas.

## Estrategia recomendada por camadas
1. Domain primeiro
- Criar/ajustar falhas de dominio tipadas (com const quando aplicavel).
- Atualizar interface do repository para AsyncResult<Sucesso, Falha>.
- Atualizar usecase para retornar AsyncResult e manter fluxo limpo.

2. Data depois
- Durante migracao, aceitar estado temporario, mas convergir para source tecnico sem Result.
- No repository impl, usar try/catch para traduzir excecoes tecnicas em falhas de dominio.
- Converter Model para Entity antes de retornar Success.

3. Presenter por ultimo
- Em ViewModel/Command, substituir catch generico por fold/map no AsyncResult.
- Emitir estados de erro com base em falhas tipadas.

## Contrato de referencia (Dominio)

```dart
import 'package:result_dart/result_dart.dart';

class LoginException implements Exception {
	final String message;
	const LoginException({required this.message});
}

class LoginInput {
	final String email;
	final String password;
	const LoginInput({required this.email, required this.password});
}

class User {
	final String id;
	final String name;
	const User({required this.id, required this.name});
}

abstract interface class UserRepository {
	AsyncResult<User, LoginException> loginWithEmailAndPassword(LoginInput input);
}

abstract interface class LoginUseCase {
	AsyncResult<User, LoginException> call(LoginInput input);
}

class LoginUseCaseImpl implements LoginUseCase {
	final UserRepository repository;
	const LoginUseCaseImpl({required this.repository});

	@override
	AsyncResult<User, LoginException> call(LoginInput input) {
		return repository.loginWithEmailAndPassword(input);
	}
}
```

## Implementacao de referencia (Repositorio concreto)

```dart
class UserRepositoryImpl implements UserRepository {
	final AuthDatasource datasource;
	const UserRepositoryImpl({required this.datasource});

	@override
	AsyncResult<User, LoginException> loginWithEmailAndPassword(LoginInput input) async {
		try {
			final model = await datasource.loginWithEmailAndPassword(
				email: input.email,
				password: input.password,
			);
			return Success(model.toEntity());
		} on SocketException {
			return const Failure(LoginException(message: 'Sem conexao com a internet.'));
		} on FormatException {
			return const Failure(LoginException(message: 'Resposta invalida do servidor.'));
		} catch (_) {
			return const Failure(LoginException(message: 'Falha ao autenticar.'));
		}
	}
}
```

## Passo a passo pratico por feature
1. Escolher um modulo pequeno e congelar escopo.
2. Inventariar metodos com try/catch tecnico no repository/usecase/presenter.
3. Criar falhas de dominio tipadas.
4. Alterar assinatura da interface do repository no Dominio para AsyncResult.
5. Refatorar repository impl para traduzir excecoes tecnicas em falha de dominio.
6. Refatorar usecase para fluxo limpo sem try/catch tecnico.
7. Refatorar vm/command para fold/map de sucesso/falha.
8. Ajustar testes por camada na mesma entrega.
9. Rodar analyze e testes focados da feature.

## Dependencia
Se ainda nao existir no modulo alvo, adicionar result_dart no app/pubspec.yaml e atualizar pacotes.

## Boas praticas
- Usar construtores const em classes imutaveis quando aplicavel.
- Evitar falha generica sem contexto de dominio.
- Preservar causa tecnica no mapeamento de falha quando fizer sentido.
- Preferir falhas tipadas a mensagens string espalhadas.
- Nao misturar metade throw e metade Result no mesmo fluxo sem criterio.

## Estrategia de transicao segura
- Migrar por metodos pequenos dentro da mesma feature.
- Manter API publica estavel enquanto adapta camadas internas.
- Se necessario, usar adaptadores temporarios e remover no final da feature.

## Anti-padroes proibidos
- Datasource retornando Result.
- UseCase com try/catch de dio/firebase/sqflite.
- Repositorio concreto retornando Model para o Dominio.
- Presenter com catch generico para montar mensagem de erro.

## Checklist de conclusao
- Interface do Repositorio no Dominio retorna AsyncResult<S, E>.
- Repositorio concreto traduz excecoes de infraestrutura para falha de dominio.
- UseCase limpo, sem try/catch tecnico.
- ViewModel/Command consumindo resultado tipado via fold/map.
- Testes atualizados por camada e executados com sucesso.
- Sem quebra de API publica fora do escopo definido.
