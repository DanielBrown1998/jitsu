<p align="center">
  <img src="../docs/DOCUMENTACAO_JITSU.png" alt="JITSU Logo" width="400"/>
</p>

<h1 align="center">🥋 JITSU</h1>

<p align="center">
  <strong>Sistema de Gestão de Academia de Jiu-Jitsu Brasileiro</strong>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white" alt="Flutter"/>
  <img src="https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white" alt="Dart"/>
  <img src="https://img.shields.io/badge/Firebase-FFCA28?style=for-the-badge&logo=firebase&logoColor=black" alt="Firebase"/>
  <img src="https://img.shields.io/badge/Version-1.0.0-blue?style=for-the-badge" alt="Version"/>
</p>

<p align="center">
  <a href="#-sobre">Sobre</a> •
  <a href="#-funcionalidades">Funcionalidades</a> •
  <a href="#-arquitetura">Arquitetura</a> •
  <a href="#-screenshots">Screenshots</a> •
  <a href="#-instalação">Instalação</a> •
  <a href="#-documentação">Documentação</a>
</p>

---

## 📖 Sobre

O **JITSU** é um sistema completo de gestão para academias de Jiu-Jitsu Brasileiro, desenvolvido para automatizar e otimizar processos administrativos, controle de alunos, registro de presenças e gerenciamento de graduações.

O sistema segue os critérios oficiais da **CBJJ (Confederação Brasileira de Jiu-Jitsu)** e **IBJJF (International Brazilian Jiu-Jitsu Federation)** para graduação de faixas.

### 🎯 Público-Alvo

| Perfil | Descrição |
|--------|-----------|
| 👨‍💼 **Administradores** | Gestores com acesso total ao sistema |
| 👨‍🏫 **Professores** | Instrutores responsáveis por turmas |
| 🥋 **Alunos** | Praticantes que acompanham seu progresso |

---

## ✨ Funcionalidades

### 🔐 Autenticação
- ✅ Login com email e senha
- ✅ Logout seguro
- ✅ Recuperação de senha

### 👥 Gestão de Alunos
- ✅ Cadastro completo de alunos
- ✅ Visualização de perfil e status
- ✅ Histórico de graduações
- ✅ Edição de dados cadastrais

### 📋 Controle de Presença
- ✅ Registro de presença em aulas
- ✅ Listagem de turmas
- ✅ Histórico de frequência
- ✅ Contador automático de aulas

### 🎖️ Sistema de Graduação
- ✅ Verificação automática de elegibilidade
- ✅ Promoção de grau e faixa
- ✅ Cálculo de progresso
- ✅ Critérios CBJJ/IBJJF oficiais

### 📊 Relatórios
- ✅ Relatório por turma
- ✅ Exportação para CSV
- ✅ Lista de alunos elegíveis
- ✅ Estatísticas de frequência

---

## 🏗️ Arquitetura

O projeto segue os princípios da **Clean Architecture**, garantindo separação de responsabilidades, testabilidade e manutenibilidade.

<p align="center">
  <img src="../docs/architecture_clean.png" alt="Clean Architecture" width="600"/>
</p>

### 📁 Estrutura de Pastas

```
lib/
├── core/
│   └── helpers/
│       └── graduacao_helper.dart    # Critérios CBJJ/IBJJF
├── domain/
│   ├── entities/                    # Modelos de domínio
│   ├── repositories/                # Interfaces
│   └── usecases/                    # Casos de uso
├── data/
│   ├── repositories/                # Implementações
│   └── datasources/                 # Fontes de dados
└── presentation/
    ├── pages/                       # Telas
    ├── widgets/                     # Componentes
    └── controllers/                 # Estado
```

---

## 🎨 Modelo de Dados

<p align="center">
  <img src="../docs/modelo_nosql.png" alt="Modelo NoSQL" width="700"/>
</p>

### Entidades Principais

| Entidade | Descrição |
|----------|-----------|
| **Aluno** | Dados do praticante + status de graduação |
| **Turma** | Grupo com horário e professor |
| **AulaRealizada** | Registro de aula com presentes |
| **HistoricoGraduacao** | Log de promoções |
| **Professor** | Instrutor responsável |

---

## 🥋 Sistema de Graduação

### Hierarquia de Faixas (Adulto)

```
⬜ BRANCA → 🟦 AZUL → 🟪 ROXA → 🟫 MARROM → ⬛ PRETA
```

### Critérios por Faixa

| Faixa | Tempo Mínimo | Aulas/Grau | Idade Mínima |
|-------|--------------|------------|--------------|
| Branca → Azul | 12 meses | 40 | 16 anos |
| Azul → Roxa | 24 meses | 50 | 16 anos |
| Roxa → Marrom | 18 meses | 50 | 18 anos |
| Marrom → Preta | 12 meses | 60 | 19 anos |

> ⚠️ **Regra Crítica**: A cada presença registrada, o contador de aulas é incrementado em +1. Ao ser promovido, o contador é zerado.

---

## 📸 Diagramas

### Casos de Uso Geral
<p align="center">
  <img src="../docs/usecases_jitsu.png" alt="Casos de Uso" width="600"/>
</p>

### Casos de Uso - Graduação
<p align="center">
  <img src="../docs/usecases_graduacao.png" alt="Graduação" width="500"/>
</p>

---

## 🚀 Instalação

### Pré-requisitos

- Flutter SDK 3.0+
- Dart 3.0+
- Android Studio / VS Code
- Conta Firebase

### Passos

```bash
# 1. Clone o repositório
git clone https://github.com/DanielBrown1998/jitsu.git

# 2. Entre na pasta do app
cd jitsu/app

# 3. Instale as dependências
flutter pub get

# 4. Configure o Firebase
flutterfire configure

# 5. Execute o app
flutter run
```

---

## 📦 Dependências

```yaml
dependencies:
  firebase_core: ^2.0.0
  firebase_auth: ^4.0.0
  cloud_firestore: ^4.0.0
  collection: ^1.17.0
```

---

## 📚 Documentação

A documentação completa está disponível em:

- 📄 [Documentação PDF](../docs/DOCUMENTACAO_JITSU.pdf)
- 📄 [Documentação HTML](../docs/DOCUMENTACAO_JITSU.html)
- 📄 [Documentação Markdown](../docs/DOCUMENTACAO_JITSU.md)

### Diagramas PlantUML

| Diagrama | Arquivo |
|----------|---------|
| Arquitetura | [architecture_clean.puml](../docs/architecture_clean.puml) |
| Modelo NoSQL | [modelo_nosql.puml](../docs/modelo_nosql.puml) |
| Casos de Uso | [usecases_jitsu.puml](../docs/usecases_jitsu.puml) |

---

## 🤝 Contribuindo

1. Faça um Fork do projeto
2. Crie sua Feature Branch (`git checkout -b feature/NovaFeature`)
3. Commit suas mudanças (`git commit -m 'Add: nova feature'`)
4. Push para a Branch (`git push origin feature/NovaFeature`)
5. Abra um Pull Request

---

## 📝 Licença

Este projeto está sob a licença MIT. Veja o arquivo [LICENSE](LICENSE) para mais detalhes.

---

## 👨‍💻 Autor

**Daniel Brown**

[![GitHub](https://img.shields.io/badge/GitHub-100000?style=for-the-badge&logo=github&logoColor=white)](https://github.com/DanielBrown1998)

---

<p align="center">
  Feito com ❤️ e ☕ para a comunidade do Jiu-Jitsu
</p>

<p align="center">
  <strong>OSS! 🥋</strong>
</p>
