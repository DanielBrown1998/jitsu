---
name: functions-deploy
description: "Use quando: preparar e executar deploy de Cloud Functions deste projeto, validando estrutura em functions/, secrets, regiao, endpoint/webhook e checks pos deploy."
argument-hint: "ambiente alvo e funcoes que devem ser publicadas"
user-invocable: true
---

# Deploy de Cloud Functions

## Objetivo
Executar deploy seguro e repetivel das Cloud Functions do projeto, com validacao de credenciais e verificacoes finais.

## Contexto deste projeto
- Pasta das functions: functions/
- A definicao de funcoes, runtime e regiao deve ser lida do codigo e da configuracao atual.
- Nao assumir nomes de funcoes, secrets ou webhook sem confirmar no repositorio.

## Pré-condicoes
1. Validar se existe codigo ativo em functions/.
2. Se functions/ estiver vazio, reportar bloqueio e orientar inicializacao da stack antes do deploy.
3. Confirmar projeto Firebase e ambiente alvo.
4. Descobrir secrets obrigatorios diretamente no codigo/configuracao.

## Procedimento
1. Pre-check
- Confirmar branch e alteracoes prontas para deploy.
- Confirmar projeto Firebase correto selecionado.
- Confirmar que os secrets obrigatorios estao definidos (sem expor valores).

2. Configurar/atualizar secrets (se necessario)
- Executar firebase functions:secrets:set apenas para secrets realmente usados no codigo.
- Nunca registrar valores de secrets em logs, commits ou mensagens.

3. Deploy
- Preferir deploy direcionado para funcoes alteradas.
- Usar deploy completo somente quando necessario.

4. Pos deploy
- Validar se funcoes subiram na regiao esperada.
- Validar endpoints/callables impactados pela mudanca.
- Validar webhook quando houver endpoint HTTP desse tipo.

5. Relatorio de deploy
- Informar o que foi publicado.
- Informar quais secrets foram usados/atualizados (sem expor valores).
- Informar status dos checks e proximos passos.

## Regras de seguranca
- Nunca expor valor de segredo em log, commit ou mensagem.
- Nunca versionar .env, .env.* ou .secret.local.
- Em caso de falha por credencial, corrigir via Secret Manager e redeploy.

## Checklist de conclusao
- Preconditions confirmadas (ou bloqueio documentado quando functions/ vazio).
- Secrets obrigatorios configurados.
- Deploy concluido sem erro.
- Endpoints/callables validados.
- Webhook validado quando aplicavel.
- Resumo final entregue com status do deploy.
