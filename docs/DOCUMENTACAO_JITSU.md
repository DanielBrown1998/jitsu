# JITSU - Sistema de Gestão de Academia de Jiu-Jitsu

![Status](https://img.shields.io/badge/Status-Em%20Desenvolvimento-yellow)
![Versão](https://img.shields.io/badge/Versão-1.0.0-blue)
![Plataforma](https://img.shields.io/badge/Plataforma-Flutter-02569B)

---

## 📋 SUMÁRIO

1. [Visão Geral](#1-visão-geral)
2. [Objetivos do Sistema](#2-objetivos-do-sistema)
3. [Arquitetura](#3-arquitetura)
4. [Modelo de Dados](#4-modelo-de-dados)
5. [Funcionalidades](#5-funcionalidades)
6. [Casos de Uso](#6-casos-de-uso)
7. [Regras de Negócio - Sistema de Graduação](#7-regras-de-negócio---sistema-de-graduação)
8. [Fluxos Principais](#8-fluxos-principais)
9. [Requisitos Técnicos](#9-requisitos-técnicos)
10. [Glossário](#10-glossário)

---

## 1. VISÃO GERAL

### 1.1 Descrição do Sistema

O **JITSU** é um sistema completo de gestão para academias de Jiu-Jitsu Brasileiro, desenvolvido para automatizar e otimizar os processos administrativos, controle de alunos, registro de presenças e gerenciamento de graduações seguindo os critérios oficiais da **CBJJ (Confederação Brasileira de Jiu-Jitsu)** e **IBJJF (International Brazilian Jiu-Jitsu Federation)**.

### 1.2 Público-Alvo

| Perfil | Descrição |
|--------|-----------|
| **Administradores** | Gestores da academia com acesso total ao sistema |
| **Professores** | Instrutores responsáveis por turmas e avaliações |
| **Alunos** | Praticantes que acompanham seu progresso |

### 1.3 Tecnologias Utilizadas

- **Frontend:** Flutter (Dart)
- **Backend:** Firebase (Firestore, Authentication)
- **Arquitetura:** Clean Architecture
- **Banco de Dados:** NoSQL (Firestore)

---

## 2. OBJETIVOS DO SISTEMA

### 2.1 Objetivo Geral

Fornecer uma solução digital completa para gestão de academias de Jiu-Jitsu, permitindo controle eficiente de alunos, turmas, presenças e graduações.

### 2.2 Objetivos Específicos

✅ Cadastrar e gerenciar alunos e professores  
✅ Organizar turmas por horário e tipo (Adulto/Kids)  
✅ Registrar presenças de forma rápida e confiável  
✅ Calcular automaticamente elegibilidade para graduações  
✅ Manter histórico completo de graduações  
✅ Gerar relatórios gerenciais  
✅ Exportar dados para análise externa (CSV)  

---

## 3. ARQUITETURA

### 3.1 Clean Architecture

O sistema segue os princípios da **Clean Architecture**, garantindo:

- **Separação de responsabilidades**
- **Testabilidade**
- **Manutenibilidade**
- **Independência de frameworks**

```
┌─────────────────────────────────────────────────────────────┐
│                      PRESENTATION                           │
│            (UI, Widgets, Controllers, BLoC)                 │
├─────────────────────────────────────────────────────────────┤
│                        DOMAIN                               │
│              (Entities, Use Cases, Interfaces)              │
├─────────────────────────────────────────────────────────────┤
│                         DATA                                │
│           (Repositories, Data Sources, Models)              │
├─────────────────────────────────────────────────────────────┤
│                       EXTERNAL                              │
│              (Firebase, APIs, Local Storage)                │
└─────────────────────────────────────────────────────────────┘
```

### 3.2 Estrutura de Pastas

```
lib/
├── core/
│   └── helpers/
│       └── graduacao_helper.dart    # Critérios CBJJ/IBJJF
├── domain/
│   ├── entities/                    # Modelos de domínio
│   ├── repositories/                # Interfaces de repositórios
│   └── usecases/                    # Casos de uso
├── data/
│   ├── repositories/                # Implementações
│   └── datasources/                 # Fontes de dados
└── presentation/
    ├── pages/                       # Telas
    ├── widgets/                     # Componentes
    └── controllers/                 # Gerenciamento de estado
```

---

## 4. MODELO DE DADOS

### 4.1 Diagrama de Entidades (NoSQL - Firestore)

```
┌─────────────────────────────────────────────────────────────┐
│                         ALUNO                                │
├─────────────────────────────────────────────────────────────┤
│ id: String (CPF)                                            │
│ nome: String                                                │
│ email: String                                               │
│ telefone: String                                            │
│ dataNascimento: String                                      │
│ turmasIds: List<String>                                     │
│ isAtivo: Boolean                                            │
│ statusGraduacao: {                                          │
│   ├── faixaAtual: String                                    │
│   ├── graus: Integer (0-4)                                  │
│   ├── dataUltimaGraduacao: DateTime                         │
│   └── aulasRealizadasNestaFaixa: Integer                    │
│ }                                                           │
└─────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────┐
│                         TURMA                                │
├─────────────────────────────────────────────────────────────┤
│ id: String                                                  │
│ nome: String                                                │
│ professorId: String                                         │
│ horarioPadrao: String                                       │
│ tipoDeTurma: Enum (adulto, kids)                            │
└─────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────┐
│                     AULA_REALIZADA                           │
├─────────────────────────────────────────────────────────────┤
│ id: String                                                  │
│ turmaId: String                                             │
│ dataHora: DateTime                                          │
│ professorResponsavel: String                                │
│ alunosPresentes: List<String>                               │
└─────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────┐
│                   HISTORICO_GRADUACAO                        │
├─────────────────────────────────────────────────────────────┤
│ id: String                                                  │
│ faixaAnterior: String                                       │
│ grauAnterior: Integer                                       │
│ faixaNova: String                                           │
│ grauNovo: Integer                                           │
│ data: DateTime                                              │
│ observacao: String?                                         │
└─────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────┐
│                   HISTORICO_PRESENCA                         │
├─────────────────────────────────────────────────────────────┤
│ id: String                                                  │
│ data: DateTime                                              │
│ turmaId: String                                             │
│ tecnicaAprendida: String?                                   │
└─────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────┐
│                       PROFESSOR                              │
├─────────────────────────────────────────────────────────────┤
│ id: String                                                  │
│ nome: String                                                │
│ turmasIds: List<String>                                     │
│ isAtivo: Boolean                                            │
└─────────────────────────────────────────────────────────────┘
```

### 4.2 Relacionamentos

| Entidade | Relacionamento | Entidade |
|----------|----------------|----------|
| Aluno | N:N | Turma |
| Turma | 1:N | AulaRealizada |
| Professor | 1:N | Turma |
| Aluno | 1:N | HistoricoGraduacao |
| Aluno | 1:N | HistoricoPresenca |

---

## 5. FUNCIONALIDADES

### 5.1 Módulo de Autenticação

| Funcionalidade | Descrição |
|----------------|-----------|
| Login com Email | Autenticação via email e senha |
| Logout | Encerramento seguro da sessão |
| Recuperar Senha | Envio de email para redefinição |

### 5.2 Módulo de Alunos

| Funcionalidade | Descrição |
|----------------|-----------|
| Cadastrar Aluno | Registro completo com dados pessoais |
| Visualizar Perfil | Exibição de dados e status de graduação |
| Histórico de Graduações | Timeline de todas as promoções |
| Editar Dados | Atualização de informações cadastrais |

### 5.3 Módulo de Presença

| Funcionalidade | Descrição |
|----------------|-----------|
| Registrar Presença | Check-in do aluno na aula |
| Listar Turmas | Visualização das turmas disponíveis |
| Histórico de Presenças | Registro de todas as aulas frequentadas |

### 5.4 Módulo de Graduação

| Funcionalidade | Descrição |
|----------------|-----------|
| Verificar Elegibilidade | Análise automática dos critérios |
| Promover Aluno | Execução da graduação (grau ou faixa) |
| Calcular Progresso | Percentual de conclusão do grau atual |

### 5.5 Módulo de Relatórios

| Funcionalidade | Descrição |
|----------------|-----------|
| Relatório de Turma | Análise completa por turma |
| Exportar CSV | Download de dados em formato CSV |
| Alunos Elegíveis | Lista de alunos prontos para graduação |

---

## 6. CASOS DE USO

### 6.1 Diagrama Geral de Casos de Uso

```
                    ┌─────────────────────────────────────┐
                    │           SISTEMA JITSU             │
                    └─────────────────────────────────────┘
                                     │
        ┌────────────────────────────┼────────────────────────────┐
        │                            │                            │
   ┌────▼────┐                 ┌─────▼─────┐                ┌─────▼─────┐
   │  AUTH   │                 │   ALUNO   │                │  PRESENÇA │
   └────┬────┘                 └─────┬─────┘                └─────┬─────┘
        │                            │                            │
   ┌────┴────┐                 ┌─────┴─────┐                ┌─────┴─────┐
   │• Login  │                 │• Cadastrar│                │• Registrar│
   │• Logout │                 │• Perfil   │                │• Listar   │
   │• Recover│                 │• Histórico│                │  Turmas   │
   └─────────┘                 └───────────┘                └───────────┘
        
        ┌────────────────────────────┼────────────────────────────┐
        │                            │                            │
   ┌────▼────┐                 ┌─────▼─────┐                      │
   │GRADUAÇÃO│                 │RELATÓRIOS │                      │
   └────┬────┘                 └─────┬─────┘                      │
        │                            │                            │
   ┌────┴────┐                 ┌─────┴─────┐                      │
   │• Verif. │                 │• Gerar    │                      │
   │  Eleg.  │                 │  Relatório│                      │
   │• Promov.│                 │• Exportar │                      │
   └─────────┘                 │  CSV      │                      │
                               └───────────┘                      │
```

### 6.2 Detalhamento dos Casos de Uso

#### UC-01: Login com Email
| Campo | Descrição |
|-------|-----------|
| **Ator Principal** | Usuário (Admin/Professor/Aluno) |
| **Pré-condição** | Usuário cadastrado no sistema |
| **Fluxo Principal** | 1. Usuário informa email e senha → 2. Sistema valida credenciais → 3. Sistema retorna token de sessão |
| **Pós-condição** | Usuário autenticado com sessão ativa |

#### UC-02: Registrar Presença
| Campo | Descrição |
|-------|-----------|
| **Ator Principal** | Professor |
| **Pré-condição** | Professor autenticado, Aula criada |
| **Fluxo Principal** | 1. Professor seleciona turma → 2. Seleciona aluno → 3. Sistema registra presença → 4. Sistema incrementa contador de aulas (+1) |
| **Pós-condição** | Presença registrada, contador atualizado |
| **Regra Crítica** | O contador `aulasRealizadasNestaFaixa` é incrementado em +1 |

#### UC-03: Verificar Elegibilidade para Graduação
| Campo | Descrição |
|-------|-----------|
| **Ator Principal** | Sistema/Professor |
| **Pré-condição** | Aluno com presenças registradas |
| **Fluxo Principal** | 1. Sistema busca dados do aluno → 2. Aplica critérios CBJJ → 3. Retorna resultado de elegibilidade |
| **Pós-condição** | Informação de elegibilidade disponível |

#### UC-04: Promover Aluno
| Campo | Descrição |
|-------|-----------|
| **Ator Principal** | Professor/Admin |
| **Pré-condição** | Aluno elegível para graduação |
| **Fluxo Principal** | 1. Professor confirma promoção → 2. Sistema atualiza faixa/grau → 3. Sistema zera contador de aulas → 4. Sistema salva histórico |
| **Pós-condição** | Aluno promovido, histórico registrado |
| **Regra Crítica** | O contador `aulasRealizadasNestaFaixa` é zerado após promoção |

---

## 7. REGRAS DE NEGÓCIO - SISTEMA DE GRADUAÇÃO

### 7.1 Sistema de Faixas do Jiu-Jitsu Brasileiro

O sistema implementa as regras oficiais da **CBJJ/IBJJF** para graduação de faixas.

#### 7.1.1 Hierarquia de Faixas (Adulto - 16+ anos)

```
┌──────────┐    ┌──────────┐    ┌──────────┐    ┌──────────┐    ┌──────────┐    ┌──────────┐
│  BRANCA  │───▶│   AZUL   │───▶│   ROXA   │───▶│  MARROM  │───▶│   PRETA  │───▶│ CORAL/   │
│          │    │          │    │          │    │          │    │          │    │ VERMELHA │
└──────────┘    └──────────┘    └──────────┘    └──────────┘    └──────────┘    └──────────┘
```

#### 7.1.2 Sistema de Graus

Cada faixa (exceto Branca e Preta) possui **4 graus** representados por listras na ponta da faixa.

```
Grau 0 ────▶ Grau 1 ────▶ Grau 2 ────▶ Grau 3 ────▶ Grau 4 ────▶ Próxima Faixa
```

### 7.2 Critérios de Graduação por Faixa

#### FAIXA BRANCA → AZUL

| Critério | Valor |
|----------|-------|
| Tempo mínimo na faixa | 12 meses |
| Aulas mínimas por grau | 40 aulas |
| Total de graus | 4 |
| Idade mínima | 16 anos |

#### FAIXA AZUL → ROXA

| Critério | Valor |
|----------|-------|
| Tempo mínimo na faixa | 24 meses |
| Aulas mínimas por grau | 50 aulas |
| Total de graus | 4 |
| Idade mínima | 16 anos |

#### FAIXA ROXA → MARROM

| Critério | Valor |
|----------|-------|
| Tempo mínimo na faixa | 18 meses |
| Aulas mínimas por grau | 50 aulas |
| Total de graus | 4 |
| Idade mínima | 18 anos |

#### FAIXA MARROM → PRETA

| Critério | Valor |
|----------|-------|
| Tempo mínimo na faixa | 12 meses |
| Aulas mínimas por grau | 60 aulas |
| Total de graus | 4 |
| Idade mínima | 19 anos |

#### FAIXA PRETA (Graus de Professor)

| Grau | Tempo Mínimo | Idade Mínima |
|------|--------------|--------------|
| 1º Grau | 3 anos | 19 anos |
| 2º Grau | 3 anos | 22 anos |
| 3º Grau | 3 anos | 25 anos |
| 4º Grau | 5 anos | 28 anos |
| 5º Grau | 5 anos | 33 anos |
| 6º Grau | 5 anos | 38 anos |

### 7.3 Fórmula de Cálculo de Progresso

```
Progresso (%) = min(100, (aulas_realizadas / aulas_necessarias) * 100)
```

### 7.4 Verificação de Elegibilidade

O sistema verifica automaticamente:

1. ✅ Número de aulas realizadas ≥ aulas necessárias
2. ✅ Tempo decorrido desde última graduação ≥ tempo mínimo
3. ✅ Idade do aluno ≥ idade mínima (quando aplicável)
4. ✅ Grau atual < máximo de graus (para subir grau)
5. ✅ Grau atual = máximo (para subir faixa)

---

## 8. FLUXOS PRINCIPAIS

### 8.1 Fluxo de Registro de Presença

```
┌─────────────┐     ┌─────────────┐     ┌─────────────┐     ┌─────────────┐
│  Professor  │────▶│  Selecionar │────▶│  Confirmar  │────▶│   Sistema   │
│  Acessa     │     │    Turma    │     │   Aluno     │     │  Registra   │
│   Sistema   │     │             │     │             │     │  Presença   │
└─────────────┘     └─────────────┘     └─────────────┘     └──────┬──────┘
                                                                    │
                                                                    ▼
┌─────────────┐     ┌─────────────┐     ┌─────────────┐     ┌─────────────┐
│  Histórico  │◀────│   Contador  │◀────│  Atualiza   │◀────│ Incrementa  │
│   Salvo     │     │ Atualizado  │     │   Aluno     │     │  Aulas +1   │
└─────────────┘     └─────────────┘     └─────────────┘     └─────────────┘
```

### 8.2 Fluxo de Graduação

```
┌─────────────┐     ┌─────────────┐     ┌─────────────┐     ┌─────────────┐
│  Professor  │────▶│  Verificar  │────▶│   Elegível  │────▶│  Confirmar  │
│  Solicita   │     │Elegibilidade│     │     ?       │     │  Promoção   │
│  Graduação  │     │             │     │             │     │             │
└─────────────┘     └─────────────┘     └──────┬──────┘     └──────┬──────┘
                                               │                    │
                                        ┌──────┴──────┐             │
                                        │             │             │
                                       NÃO           SIM            │
                                        │             │             │
                                        ▼             ▼             ▼
                                ┌─────────────┐ ┌─────────────┐ ┌─────────────┐
                                │   Exibir    │ │  Atualizar  │ │   Salvar    │
                                │   Motivo    │ │ Faixa/Grau  │ │  Histórico  │
                                │             │ │             │ │             │
                                └─────────────┘ └──────┬──────┘ └─────────────┘
                                                       │
                                                       ▼
                                               ┌─────────────┐
                                               │   Zerar     │
                                               │  Contador   │
                                               │   Aulas     │
                                               └─────────────┘
```

### 8.3 Fluxo de Geração de Relatório

```
┌─────────────┐     ┌─────────────┐     ┌─────────────┐     ┌─────────────┐
│   Admin     │────▶│  Selecionar │────▶│  Definir    │────▶│   Gerar     │
│  Acessa     │     │    Turma    │     │   Período   │     │  Relatório  │
│  Relatórios │     │             │     │             │     │             │
└─────────────┘     └─────────────┘     └─────────────┘     └──────┬──────┘
                                                                    │
                                                                    ▼
┌─────────────┐     ┌─────────────┐     ┌─────────────┐     ┌─────────────┐
│   Exibir    │◀────│  Calcular   │◀────│   Buscar    │◀────│  Processar  │
│  Resultado  │     │  Métricas   │     │   Dados     │     │   Dados     │
└─────────────┘     └─────────────┘     └─────────────┘     └─────────────┘
```

---

## 9. REQUISITOS TÉCNICOS

### 9.1 Requisitos de Hardware (Mobile)

| Componente | Mínimo | Recomendado |
|------------|--------|-------------|
| RAM | 2 GB | 4 GB |
| Armazenamento | 100 MB | 200 MB |
| Processador | Dual-core | Quad-core |

### 9.2 Requisitos de Software

| Componente | Versão |
|------------|--------|
| Android | 6.0+ (API 23) |
| iOS | 12.0+ |
| Flutter SDK | 3.0+ |
| Dart | 3.0+ |

### 9.3 Dependências do Projeto

| Pacote | Versão | Descrição |
|--------|--------|-----------|
| firebase_core | ^2.0.0 | Core do Firebase |
| firebase_auth | ^4.0.0 | Autenticação |
| cloud_firestore | ^4.0.0 | Banco de dados |
| collection | ^1.17.0 | Utilitários de coleção |

### 9.4 Requisitos de Conectividade

- Conexão com internet para sincronização
- Suporte a modo offline (cache local)

---

## 10. GLOSSÁRIO

| Termo | Definição |
|-------|-----------|
| **CBJJ** | Confederação Brasileira de Jiu-Jitsu |
| **IBJJF** | International Brazilian Jiu-Jitsu Federation |
| **Faixa** | Graduação que indica o nível do praticante |
| **Grau** | Subdivisão dentro de cada faixa (0 a 4) |
| **Presença** | Registro de participação do aluno em uma aula |
| **Turma** | Grupo de alunos com horário definido |
| **Clean Architecture** | Padrão arquitetural que separa regras de negócio de frameworks |
| **Use Case** | Caso de uso - ação específica do sistema |
| **Entity** | Entidade de domínio com regras de negócio |
| **Repository** | Interface de acesso a dados |
| **Firestore** | Banco de dados NoSQL do Firebase |

---

## 📞 SUPORTE

Para suporte técnico ou dúvidas sobre o sistema:

- **Email:** suporte@jitsu.app
- **Documentação:** https://docs.jitsu.app
- **GitHub:** https://github.com/DanielBrown1998/jitsu

---

## 📄 CONTROLE DE VERSÃO DO DOCUMENTO

| Versão | Data | Autor | Descrição |
|--------|------|-------|-----------|
| 1.0.0 | 28/01/2026 | Equipe Jitsu | Versão inicial |

---

*Documento gerado automaticamente pelo Sistema JITSU*
*© 2026 - Todos os direitos reservados*
