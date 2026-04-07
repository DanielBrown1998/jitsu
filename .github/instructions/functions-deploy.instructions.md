---
description: "Use when deploying Cloud Functions, configuring secrets, validating webhooks or troubleshooting function deployment. Load skill functions-deploy."
name: "Functions Deploy Workflow"
---

# Functions Deploy Workflow

- Para qualquer tarefa de deploy de functions, usar a skill functions-deploy.
- Antes de qualquer deploy, validar se existe codigo ativo em functions/.
- Se functions/ estiver vazio, informar bloqueio de deploy e sugerir criacao/configuracao inicial.
- Validar secrets obrigatorios com base no codigo e na documentacao vigente da pasta functions/.
- Confirmar regiao configurada nas funcoes antes do deploy.
- Nunca expor valores de secrets em logs, mensagens ou commits.
