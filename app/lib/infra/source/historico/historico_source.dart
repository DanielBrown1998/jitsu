import 'package:app/domain/entities/historico_presenca.dart';
import 'package:app/domain/repositories/historico/i_historico_repository.dart';
import 'package:app/core/error/exceptions.dart';
import 'package:app/infra/models/historico_presenca_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:result_dart/result_dart.dart';

abstract class HistoricoPresencaSource implements IHistoricoPresencaWorkflow {}

class HistoricoPresencaSourceImpl implements HistoricoPresencaSource {
  final FirebaseFirestore firestore;

  HistoricoPresencaSourceImpl({required this.firestore});

  CollectionReference<Map<String, dynamic>> get _historicos =>
      firestore.collection('historicos_presenca');

  @override
  AsyncResult<Unit> create(String alunoId, HistoricoPresenca presenca) async {
    try {
      final model = HistoricoPresencaModel.fromEntity(presenca);
      final docRef = model.id.isEmpty
          ? _historicos.doc()
          : _historicos.doc(model.id);
      await docRef.set({...model.toMap(), 'alunoId': alunoId, 'id': docRef.id});
      return const Success(unit);
    } on FirebaseException catch (e) {
      return Failure(
        DatabaseException(
          'Falha ao criar histórico de presença: ${e.message ?? e.code}',
        ),
      );
    }
  }
}
