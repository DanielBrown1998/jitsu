"""
Script para gerar dados fake no Cloud Firestore para o projeto Jitsu.

Uso:
    python generate_fakes.py

Requisitos:
    pip install firebase-admin faker
    
Configuração Firebase:
    1. Baixe o arquivo JSON de credenciais do Firebase Console
    2. Exporte a variável: GOOGLE_APPLICATION_CREDENTIALS=/path/to/seervice-account.json
    3. Execute o script
"""

import firebase_admin
from firebase_admin import credentials
from firebase_admin import firestore
from faker import Faker
from datetime import datetime, timedelta
import random
import string
from typing import List, Dict
import os

# Inicializar Firebase
script_dir = os.path.dirname(os.path.abspath(__file__))
cred_path = os.path.join(script_dir, 'serviceAccountKey.json')

if not os.path.exists(cred_path):
    raise FileNotFoundError(
        f"❌ Arquivo de credenciais não encontrado em: {cred_path}\n"
        f"Por favor, baixe o arquivo serviceAccountKey.json do Firebase Console "
        f"e salve em: {cred_path}"
    )

cred = credentials.Certificate(cred_path)
firebase_admin.initialize_app(cred)

db = firestore.client()
fake = Faker('pt_BR')

# Configuração de quantidades
NUM_PROFESSORS = 6
NUM_TURMAS_PER_PROFESSOR = 2
NUM_ALUNOS = 50
AULAS_PER_TURMA = 8

# Enums
TIPO_TURMA = ['adulto', 'kids']
FAIXAS = ['branca', 'amarela', 'laranja', 'verde', 'azul', 'roxa', 'marrom', 'preta']


def gerar_id_unico(prefix: str) -> str:
    """Gera ID único com prefixo."""
    random_str = ''.join(random.choices(string.ascii_lowercase + string.digits, k=10))
    return f"{prefix}_{random_str}"


def criar_professors() -> List[Dict]:
    """Cria dados de professores."""
    professors = []
    for i in range(NUM_PROFESSORS):
        prof_id = gerar_id_unico("prof")
        professor = {
            'id': prof_id,
            'nome': fake.name(),
            'email': fake.email(),
            'telefone': fake.phone_number()[:15],
            'turmasIds': [],
            'isAtivo': True,
        }
        professors.append(professor)
    return professors


def criar_status_graduacao() -> Dict:
    """Cria um status de graduação inicial."""
    return {
        'faixaAtual': random.choice(FAIXAS[:4]),  # Faixas iniciais
        'graus': random.randint(0, 4),
        'dataUltimaGraduacao': datetime.now().isoformat(),
        'aulasRealizadasNestaFaixa': random.randint(0, 30),
    }


def criar_turmas(professors: List[Dict]) -> List[Dict]:
    """Cria turmas associadas aos professores."""
    turmas = []
    turma_ids_por_professor = {prof['id']: [] for prof in professors}
    
    for professor in professors:
        for _ in range(NUM_TURMAS_PER_PROFESSOR):
            turma_id = gerar_id_unico("turma")
            turma = {
                'id': turma_id,
                'nome': f"Turma {fake.word().capitalize()} - {fake.first_name()}",
                'professorId': professor['id'],
                'horarioPadrao': f"{random.randint(6, 19)}:{random.randint(0, 5)*10:02d}",
                'tipoDeTurma': random.choice(TIPO_TURMA),
            }
            turmas.append(turma)
            turma_ids_por_professor[professor['id']].append(turma_id)
    
    # Atualizar turmasIds dos professores
    for professor in professors:
        professor['turmasIds'] = turma_ids_por_professor[professor['id']]
    
    return turmas


def criar_alunos(turmas: List[Dict]) -> List[Dict]:
    """Cria alunos associados às turmas."""
    alunos = []
    turma_ids = [turma['id'] for turma in turmas]
    
    for i in range(NUM_ALUNOS):
        aluno_id = gerar_id_unico("aluno")
        # Cada aluno em 1-3 turmas
        turmas_do_aluno = random.sample(turma_ids, k=random.randint(1, 3))
        
        aluno = {
            'id': aluno_id,
            'nome': fake.name(),
            'email': fake.email(),
            'telefone': fake.phone_number()[:15],
            'dataNascimento': fake.date_of_birth(minimum_age=5, maximum_age=70).isoformat(),
            'turmasIds': turmas_do_aluno,
            'statusGraduacao': criar_status_graduacao(),
            'isAtivo': random.choice([True, True, True, False]),  # 75% ativos
        }
        alunos.append(aluno)
    
    return alunos


def criar_aulas_realizadas(turmas: List[Dict], alunos: List[Dict]) -> List[Dict]:
    """Cria aulas realizadas para cada turma."""
    aulas = []
    # Mapa de alunos por turma
    alunos_por_turma = {turma['id']: [] for turma in turmas}
    for aluno in alunos:
        for turma_id in aluno['turmasIds']:
            if turma_id in alunos_por_turma:
                alunos_por_turma[turma_id].append(aluno['id'])
    
    for turma in turmas:
        alunos_na_turma = alunos_por_turma[turma['id']]
        if not alunos_na_turma:
            continue
        
        for i in range(AULAS_PER_TURMA):
            aula_id = gerar_id_unico("aula")
            data_aula = datetime.now() - timedelta(days=random.randint(1, 90))
            
            # 80% de presença média
            num_presentes = max(1, int(len(alunos_na_turma) * random.uniform(0.6, 1.0)))
            alunosPresentes = random.sample(alunos_na_turma, k=num_presentes)
            
            aula = {
                'id': aula_id,
                'turmaId': turma['id'],
                'dataHora': data_aula.isoformat(),
                'professorResponsavel': turma['professorId'],
                'alunosPresentes': alunosPresentes,
            }
            aulas.append(aula)
    
    return aulas


def criar_historicos_presenca(alunos: List[Dict]) -> List[Dict]:
    """Cria históricos de presença para alunos."""
    historicos_presenca = []
    
    for aluno in alunos:
        # 3-10 registros de presença por aluno
        for _ in range(random.randint(3, 10)):
            historico_id = gerar_id_unico("hist_pres")
            data = datetime.now() - timedelta(days=random.randint(1, 120))
            
            historico = {
                'id': historico_id,
                'data': data.isoformat(),
                'turmaId': random.choice(aluno['turmasIds']) if aluno['turmasIds'] else 'sem-turma',
                'tecnicaAprendida': fake.word() if random.random() > 0.3 else None,
            }
            historicos_presenca.append(historico)
    
    return historicos_presenca


def criar_historicos_graduacao(alunos: List[Dict]) -> List[Dict]:
    """Cria históricos de graduação para alunos."""
    historicos_grad = []
    
    for aluno in alunos:
        # Alguns alunos tiveram promoções
        if random.random() > 0.6:
            faixas_ordenadas = FAIXAS
            idx_faixa_atual = faixas_ordenadas.index(aluno['statusGraduacao']['faixaAtual'])
            
            if idx_faixa_atual < len(faixas_ordenadas) - 1:
                historico_id = gerar_id_unico("hist_grad")
                faixa_anterior = faixas_ordenadas[idx_faixa_atual]
                faixa_nova = faixas_ordenadas[idx_faixa_atual + 1]
                
                historico = {
                    'id': historico_id,
                    'faixaAnterior': faixa_anterior,
                    'grauAnterior': aluno['statusGraduacao']['graus'],
                    'faixaNova': faixa_nova,
                    'grauNovo': random.randint(0, 4),
                    'data': (datetime.now() - timedelta(days=random.randint(30, 300))).isoformat(),
                    'observacao': fake.sentence(nb_words=5) if random.random() > 0.5 else None,
                }
                historicos_grad.append(historico)
    
    return historicos_grad


def salvar_no_firestore(colecao: str, documentos: List[Dict]):
    """Salva documentos no Firestore."""
    print(f"Salvando {len(documentos)} documentos na coleção '{colecao}'...")
    batch = db.batch()
    
    for i, doc in enumerate(documentos):
        doc_ref = db.collection(colecao).document(doc['id'])
        batch.set(doc_ref, doc)
        
        # Firestore tem limite de 500 operações por batch
        if (i + 1) % 500 == 0:
            batch.commit()
            batch = db.batch()
            print(f"  ... {i + 1}/{len(documentos)} salvo")
    
    if len(documentos) > 0:
        batch.commit()
    print(f"✓ {colecao} concluído")


def main():
    """Função principal."""
    print("🚀 Iniciando geração de dados fake para Firestore...\n")
    
    try:
        # 1. Criar e salvar Professores
        print("📚 Gerando Professores...")
        professors = criar_professors()
        salvar_no_firestore('professores', professors)
        print()
        
        # 2. Criar e salvar Turmas
        print("📚 Gerando Turmas...")
        turmas = criar_turmas(professors)
        salvar_no_firestore('turmas', turmas)
        # Atualizar professores com turmasIds
        salvar_no_firestore('professores', professors)
        print()
        
        # 3. Criar e salvar Alunos
        print("📚 Gerando Alunos...")
        alunos = criar_alunos(turmas)
        salvar_no_firestore('alunos', alunos)
        print()
        
        # 4. Criar e salvar Aulas Realizadas
        print("📚 Gerando Aulas Realizadas...")
        aulas = criar_aulas_realizadas(turmas, alunos)
        salvar_no_firestore('aulas_realizadas', aulas)
        print()
        
        # 5. Criar e salvar Históricos de Presença
        print("📚 Gerando Históricos de Presença...")
        historicos_pres = criar_historicos_presenca(alunos)
        salvar_no_firestore('historicos_presenca', historicos_pres)
        print()
        
        # 6. Criar e salvar Históricos de Graduação
        print("📚 Gerando Históricos de Graduação...")
        historicos_grad = criar_historicos_graduacao(alunos)
        salvar_no_firestore('historicos_graduacao', historicos_grad)
        print()
        
        print("✅ Todos os dados foram gerados e salvos no Firestore com sucesso!")
        print(f"""
Resumo:
  - {len(professors)} Professores
  - {len(turmas)} Turmas
  - {len(alunos)} Alunos
  - {len(aulas)} Aulas Realizadas
  - {len(historicos_pres)} Históricos de Presença
  - {len(historicos_grad)} Históricos de Graduação
        """)
        
    except Exception as e:
        print(f"❌ Erro ao gerar dados: {e}")
        raise


if __name__ == '__main__':
    main()
