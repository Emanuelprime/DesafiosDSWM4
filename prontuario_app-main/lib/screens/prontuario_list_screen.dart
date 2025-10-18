import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:prontuario_app/screens/formulario_prontuario_screen.dart';

import '../models/prontuario.dart';
import '../services/firestore_service.dart';

class ProntuarioListScreen extends StatelessWidget {
  final FirestoreService firestoreService = FirestoreService();

  ProntuarioListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Prontuários'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Logout realizado com sucesso!'),
                  ),
                );
              }
            },
            tooltip: 'Sair',
          ),
        ],
      ),
      body: StreamBuilder<List<Prontuario>>(
        stream: firestoreService.getProntuarios(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Erro: ${snapshot.error}'));
          }

          if (snapshot.connectionState == ConnectionState.waiting)
            return Center(child: CircularProgressIndicator());

          final prontuarios = snapshot.data ?? [];

          if (prontuarios.isEmpty) {
            return Center(child: Text('Nenhum prontuário encontrado'));
          }

          return ListView.builder(
            itemCount: prontuarios.length,
            itemBuilder: (context, index) {
              final p = prontuarios[index];
              return ListTile(
                title: Text(p.paciente),
                subtitle: Text(p.descricao),
                trailing: IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () => firestoreService.deletarProntuario(p.id!),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => FormularioProntuarioScreen()),
        ),
        child: Icon(Icons.add),
      ),
    );
  }
}
