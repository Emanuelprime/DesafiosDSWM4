import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/prontuario.dart';

class FirestoreService {
  final CollectionReference prontuariosCollection = FirebaseFirestore.instance
      .collection('prontuarios');

  Future<void> adicionarProntuario(Prontuario prontuario) async {
     try {
      final docRef = await prontuariosCollection.add(prontuario.toMap());
      print('Firestore add succeeded: ${docRef.id}');
    } on FirebaseException catch (e) {
      print('Firestore write failed: ${e.code} ${e.message}');
      rethrow;
    } catch (e, st) {
      print('Unknown error adding prontuario: $e\n$st');
      rethrow;
    }
  }

  Future<void> deletarProntuario(String id) async {
    await prontuariosCollection.doc(id).delete();
  }

  Future<void> atualizarProntuario(Prontuario prontuario) async {
    if (prontuario.id == null) {
      throw ArgumentError('Documento precisa de um ID valido');
    }

    try {
      await prontuariosCollection.doc(prontuario.id).update(prontuario.toMap());
      print('Firestore atualizado com sucesso: ${prontuario.id}');
    } on FirebaseException catch (e) {
      print('Falha ao atualizar Firestore: ${e.code} ${e.message}');
      rethrow;
    } catch (e, st) {
      print('Erro desconhecido ao atualizar prontuario: $e\n$st');
      rethrow;
    }
  }

  Stream<List<Prontuario>> getProntuarios() {
    return prontuariosCollection.snapshots().map(
      (snapshot) => snapshot.docs
          .map(
            (doc) =>
                Prontuario.fromMap(doc.id, doc.data() as Map<String, dynamic>),
          )
          .toList(),
    );
  }
}
