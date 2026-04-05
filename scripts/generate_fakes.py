from __future__ import annotations

"""
Credenciais para teste (3 alunos):
  - email: aluno001@jitsu.test | senha: Aluno@101 | uid: Ulx3ASguyGSBpKTUoo8APBMhzrf2
  - email: aluno002@jitsu.test | senha: Aluno@102 | uid: naOcRwCNvnPoDpED0AdaAJWM8wm1
  - email: aluno003@jitsu.test | senha: Aluno@103 | uid: gV64TcrW7YZH4kqhLukRAxqovrq2
"""

"""Seed completo do Firebase para o projeto Jitsu.

O script faz:
1. Limpeza total das colecoes usadas pelo app no Firestore.
2. Recriacao de admin/professores com UIDs fixos definidos no codigo.
3. Criacao de turmas (cada professor com ao menos 1 turma).
4. Criacao de contas de alunos no Firebase Auth e respectivos documentos no Firestore.
5. Vinculo dos alunos as turmas + aulas e historicos.

Uso:
    python generate_fakes.py

Requisitos:
    pip install firebase-admin faker
"""


from datetime import datetime, timedelta
import os
import random
import string
import sys
from typing import Dict, List, Tuple

import firebase_admin
from firebase_admin import auth, credentials, firestore
from faker import Faker


# =============================
# Configuracao fixa de usuarios
# =============================

ADMIN_ACCOUNT = {
    "uid": "4rE575UaEzPcmbQHosUmM3yK5Tz2",
    "nome": "Daniel",
    "email": "db7somais7@gmail.com",
}

PROFESSOR_ACCOUNTS = [
    {
        "uid": "76Nv1FKckTWh3e241p2a7QJA9Mw1",
        "nome": "Carlos",
        "email": "daniel_mingozzi@hotmail.com",
    },
    {
        "uid": "3dTv3QTCzcRoBneJJLHB9k62Uzg2",
        "nome": "Bruno",
        "email": "daniel_profissional1998@hotmail.com",
    },
    {
        "uid": "no1TJkf0zhYonTncNQqudO90fsQ2",
        "nome": "Rafael",
        "email": "daniel_academico1998@hotmail.com",
    },
]


# =============================
# Parametros de geracao
# =============================

NUM_TURMAS_PER_PROFESSOR = 2
NUM_ALUNOS = 24
AULAS_PER_TURMA = 6

TIPO_TURMA = ["Adulto", "Kids"]
FAIXAS = ["Branca", "Amarela", "Laranja", "Verde", "Azul", "Roxa", "Marrom", "Preta"]

COLLECTIONS_TO_WIPE = [
    "users",
    "professores",
    "turmas",
    "alunos",
    "aulas_realizadas",
    "historicos_presenca",
    "historicos_graduacao",
]


# =============================
# Inicializacao Firebase
# =============================

script_dir = os.path.dirname(os.path.abspath(__file__))
cred_path = os.path.join(script_dir, "serviceAccountKey.json")

if not os.path.exists(cred_path):
    raise FileNotFoundError(
        f"Arquivo de credenciais nao encontrado em: {cred_path}\n"
        f"Baixe o serviceAccountKey.json no Firebase Console e salve nesse caminho."
    )

cred = credentials.Certificate(cred_path)
firebase_admin.initialize_app(cred)

db = firestore.client()
fake = Faker("pt_BR")


def gerar_id_unico(prefix: str) -> str:
    sufixo = "".join(random.choices(string.ascii_lowercase + string.digits, k=10))
    return f"{prefix}_{sufixo}"


def to_millis(value: datetime) -> int:
    return int(value.timestamp() * 1000)


def apagar_colecao(nome_colecao: str, lote: int = 300) -> int:
    total = 0
    while True:
        # Evita ficar 5 minutos em retries quando as credenciais estao invalidas.
        docs = list(
            db.collection(nome_colecao).limit(lote).stream(retry=None, timeout=30)
        )
        if not docs:
            break

        batch = db.batch()
        for doc in docs:
            batch.delete(doc.reference)
            total += 1
        batch.commit()

    return total


def limpar_firestore() -> None:
    print("Limpando dados atuais do Firestore...")
    total_geral = 0
    for colecao in COLLECTIONS_TO_WIPE:
        removidos = apagar_colecao(colecao)
        total_geral += removidos
        print(f"  - {colecao}: {removidos} removidos")
    print(f"Total removido: {total_geral}\n")


def upsert_auth_user(uid: str, email: str, display_name: str) -> str:
    """Garante que o usuario existe no Firebase Auth sem alterar senha existente."""
    try:
        user = auth.get_user(uid)
        return user.email or email
    except auth.UserNotFoundError:
        user = auth.create_user(
            uid=uid,
            email=email,
            password="Professor@123",
            display_name=display_name,
            email_verified=True,
        )
        return user.email or email


def criar_status_graduacao() -> Dict:
    return {
        "faixaAtual": random.choice(FAIXAS[:4]),
        "graus": random.randint(0, 4),
        "dataUltimaGraduacao": to_millis(
            datetime.now() - timedelta(days=random.randint(60, 500))
        ),
        "aulasRealizadasNestaFaixa": random.randint(0, 30),
    }


def criar_turmas(professores: List[Dict]) -> List[Dict]:
    turmas: List[Dict] = []
    for professor in professores:
        for i in range(NUM_TURMAS_PER_PROFESSOR):
            turma_id = gerar_id_unico("turma")
            turma = {
                "id": turma_id,
                "nome": f"Turma {i + 1} - {professor['nome'].split()[0]}",
                "professorId": professor["id"],
                "horarioPadrao": f"{random.randint(6, 20)}:{random.choice([0, 10, 20, 30, 40, 50]):02d}",
                "tipoDeTurma": random.choice(TIPO_TURMA),
                "diasSemana": sorted(
                    random.sample(range(1, 8), k=random.randint(2, 4))
                ),
            }
            turmas.append(turma)
            professor["turmasIds"].append(turma_id)
    return turmas


def criar_contas_e_documentos_alunos(turmas: List[Dict]) -> Tuple[List[Dict], List[Dict]]:
    alunos: List[Dict] = []
    credenciais: List[Dict] = []
    turma_ids = [turma["id"] for turma in turmas]

    for i in range(1, NUM_ALUNOS + 1):
        aluno_email = f"aluno{i:03d}@jitsu.test"
        aluno_senha = f"Aluno@{100 + i}"
        nome = fake.name()

        # Reaproveita conta se ja existir por email, senao cria.
        try:
            user = auth.get_user_by_email(aluno_email)
        except auth.UserNotFoundError:
            user = auth.create_user(
                email=aluno_email,
                password=aluno_senha,
                display_name=nome,
                email_verified=True,
            )

        turmas_do_aluno = random.sample(turma_ids, k=random.randint(1, min(3, len(turma_ids))))
        aluno = {
            "id": user.uid,
            "nome": nome,
            "email": aluno_email,
            "telefone": fake.phone_number()[:15],
            "dataNascimento": fake.date_of_birth(minimum_age=8, maximum_age=60).isoformat(),
            "turmasIds": turmas_do_aluno,
            "statusGraduacao": criar_status_graduacao(),
            "isAtivo": True,
        }

        alunos.append(aluno)
        credenciais.append({"email": aluno_email, "senha": aluno_senha, "uid": user.uid})

    return alunos, credenciais


def criar_aulas_realizadas(turmas: List[Dict], alunos: List[Dict]) -> List[Dict]:
    aulas: List[Dict] = []
    alunos_por_turma: Dict[str, List[str]] = {turma["id"]: [] for turma in turmas}

    for aluno in alunos:
        for turma_id in aluno["turmasIds"]:
            alunos_por_turma[turma_id].append(aluno["id"])

    for turma in turmas:
        alunos_na_turma = alunos_por_turma[turma["id"]]
        if not alunos_na_turma:
            continue

        for _ in range(AULAS_PER_TURMA):
            data_aula = datetime.now() - timedelta(days=random.randint(1, 120))
            presentes = random.sample(
                alunos_na_turma,
                k=max(1, int(len(alunos_na_turma) * random.uniform(0.6, 1.0))),
            )
            aulas.append(
                {
                    "id": gerar_id_unico("aula"),
                    "turmaId": turma["id"],
                    "dataHora": to_millis(data_aula),
                    "professorResponsavel": turma["professorId"],
                    "alunosPresentes": presentes,
                }
            )

    return aulas


def criar_historicos_presenca(alunos: List[Dict]) -> List[Dict]:
    historicos: List[Dict] = []
    for aluno in alunos:
        for _ in range(random.randint(3, 8)):
            historicos.append(
                {
                    "id": gerar_id_unico("hist_pres"),
                    "alunoId": aluno["id"],
                    "data": to_millis(datetime.now() - timedelta(days=random.randint(1, 180))),
                    "turmaId": random.choice(aluno["turmasIds"]),
                    "tecnicaAprendida": fake.word() if random.random() > 0.35 else None,
                }
            )
    return historicos


def criar_historicos_graduacao(alunos: List[Dict]) -> List[Dict]:
    historicos: List[Dict] = []
    for aluno in alunos:
        if random.random() < 0.45:
            continue

        faixa_atual = aluno["statusGraduacao"]["faixaAtual"]
        idx = FAIXAS.index(faixa_atual)
        if idx >= len(FAIXAS) - 1:
            continue

        historicos.append(
            {
                "id": gerar_id_unico("hist_grad"),
                "alunoId": aluno["id"],
                "faixaAnterior": faixa_atual,
                "grauAnterior": aluno["statusGraduacao"]["graus"],
                "faixaNova": FAIXAS[idx + 1],
                "grauNovo": random.randint(0, 4),
                "data": to_millis(datetime.now() - timedelta(days=random.randint(45, 365))),
                "observacao": fake.sentence(nb_words=5) if random.random() > 0.5 else None,
            }
        )

    return historicos


def salvar_no_firestore(colecao: str, documentos: List[Dict]) -> None:
    print(f"Salvando {len(documentos)} documentos em '{colecao}'...")
    if not documentos:
        print("  - sem documentos")
        return

    batch = db.batch()
    for idx, doc in enumerate(documentos, start=1):
        doc_ref = db.collection(colecao).document(doc["id"])
        batch.set(doc_ref, doc)

        if idx % 450 == 0:
            batch.commit()
            batch = db.batch()

    batch.commit()
    print("  - concluido")


def main() -> None:
    print("Iniciando reset + seed do Firebase...\n")

    limpar_firestore()

    # Garante documentos de usuarios admin/professores respeitando UIDs fixos.
    admin_email = upsert_auth_user(
        uid=ADMIN_ACCOUNT["uid"],
        email=ADMIN_ACCOUNT["email"],
        display_name=ADMIN_ACCOUNT["nome"],
    )

    professores: List[Dict] = []
    users_docs: List[Dict] = [
        {
            "id": ADMIN_ACCOUNT["uid"],
            "userId": ADMIN_ACCOUNT["uid"],
            "nome": ADMIN_ACCOUNT["nome"],
            "email": admin_email.lower(),
            "role": "admin",
            "isAtivo": True,
            "createdAt": firestore.SERVER_TIMESTAMP,
            "updatedAt": firestore.SERVER_TIMESTAMP,
        }
    ]

    for professor_cfg in PROFESSOR_ACCOUNTS:
        prof_email = upsert_auth_user(
            uid=professor_cfg["uid"],
            email=professor_cfg["email"],
            display_name=professor_cfg["nome"],
        )

        professores.append(
            {
                "id": professor_cfg["uid"],
                "nome": professor_cfg["nome"],
                "turmasIds": [],
                "isAtivo": True,
            }
        )

        users_docs.append(
            {
                "id": professor_cfg["uid"],
                "userId": professor_cfg["uid"],
                "nome": professor_cfg["nome"],
                "email": prof_email.lower(),
                "role": "professor",
                "isAtivo": True,
                "createdAt": firestore.SERVER_TIMESTAMP,
                "updatedAt": firestore.SERVER_TIMESTAMP,
            }
        )

    turmas = criar_turmas(professores)
    alunos, credenciais_alunos = criar_contas_e_documentos_alunos(turmas)

    # users docs para alunos
    for aluno in alunos:
        users_docs.append(
            {
                "id": aluno["id"],
                "userId": aluno["id"],
                "nome": aluno["nome"],
                "email": aluno["email"].lower(),
                "role": "student",
                "isAtivo": True,
                "createdAt": firestore.SERVER_TIMESTAMP,
                "updatedAt": firestore.SERVER_TIMESTAMP,
            }
        )

    aulas = criar_aulas_realizadas(turmas, alunos)
    historicos_presenca = criar_historicos_presenca(alunos)
    historicos_graduacao = criar_historicos_graduacao(alunos)

    salvar_no_firestore("users", users_docs)
    salvar_no_firestore("professores", professores)
    salvar_no_firestore("turmas", turmas)
    salvar_no_firestore("alunos", alunos)
    salvar_no_firestore("aulas_realizadas", aulas)
    salvar_no_firestore("historicos_presenca", historicos_presenca)
    salvar_no_firestore("historicos_graduacao", historicos_graduacao)

    print("\nSeed finalizado com sucesso.")
    print("Resumo:")
    print(f"  - users: {len(users_docs)}")
    print(f"  - professores: {len(professores)}")
    print(f"  - turmas: {len(turmas)}")
    print(f"  - alunos: {len(alunos)}")
    print(f"  - aulas_realizadas: {len(aulas)}")
    print(f"  - historicos_presenca: {len(historicos_presenca)}")
    print(f"  - historicos_graduacao: {len(historicos_graduacao)}")

    print("\nCredenciais para teste (3 alunos):")
    for aluno in credenciais_alunos[:3]:
        print(f"  - email: {aluno['email']} | senha: {aluno['senha']} | uid: {aluno['uid']}")


def _print_auth_clock_hint(exc: Exception) -> bool:
    message = str(exc)
    is_invalid_grant = "invalid_grant" in message and "Token must be a short-lived token" in message

    if not is_invalid_grant:
        return False

    print("\nERRO DE AUTENTICACAO COM FIREBASE")
    print(
        "Causa provavel: relogio do Windows fora de sincronia (iat/exp do JWT fora da janela)."
    )
    print("\nComo corrigir:")
    print("1. Abra o PowerShell como Administrador.")
    print("2. Execute: w32tm /resync /force")
    print("3. Confirme com: w32tm /query /status")
    print("4. Rode o script novamente: python generate_fakes.py")
    print(
        "\nSe persistir, gere uma nova chave serviceAccountKey.json no Firebase Console e substitua a atual."
    )
    return True


if __name__ == "__main__":
    try:
        main()
    except Exception as exc:
        handled = _print_auth_clock_hint(exc)
        if handled:
            sys.exit(1)
        raise
