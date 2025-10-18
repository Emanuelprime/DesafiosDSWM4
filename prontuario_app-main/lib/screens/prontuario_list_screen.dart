import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:prontuario_app/screens/formulario_prontuario_screen.dart';
import 'package:prontuario_app/screens/login_screen.dart';

import '../models/prontuario.dart';
import '../services/firestore_service.dart';

class ProntuarioListScreen extends StatefulWidget {
  const ProntuarioListScreen({super.key});

  @override
  State<ProntuarioListScreen> createState() => _ProntuarioListScreenState();
}

class _ProntuarioListScreenState extends State<ProntuarioListScreen> {
  final FirestoreService firestoreService = FirestoreService();
  final TextEditingController _searchController = TextEditingController();
  final ValueNotifier<String> _searchQuery = ValueNotifier<String>('');

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      _searchQuery.value = _searchController.text;
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchQuery.dispose();
    super.dispose();
  }

  List<Prontuario> _filterProntuarios(
    List<Prontuario> prontuarios,
    String query,
  ) {
    if (query.isEmpty) {
      return prontuarios;
    }

    return prontuarios.where((p) {
      return p.paciente.toLowerCase().contains(query.toLowerCase());
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Prontuários'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              // Show loading dialog
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (context) =>
                    const Center(child: CircularProgressIndicator()),
              );

              try {
                await FirebaseAuth.instance.signOut();

                if (context.mounted) {
                  // Close loading dialog
                  Navigator.of(context).pop();

                  // Navigate to login screen and remove all previous routes
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (_) => const LoginScreen()),
                    (route) => false,
                  );

                  // Show success message on the login screen
                  Future.delayed(const Duration(milliseconds: 300), () {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Logout realizado com sucesso!'),
                        ),
                      );
                    }
                  });
                }
              } catch (e) {
                if (context.mounted) {
                  // Close loading dialog
                  Navigator.of(context).pop();

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Erro ao fazer logout: $e')),
                  );
                }
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

          final allProntuarios = snapshot.data ?? [];

          return ValueListenableBuilder<String>(
            valueListenable: _searchQuery,
            builder: (context, searchValue, _) {
              final prontuarios = _filterProntuarios(
                allProntuarios,
                searchValue,
              );

              return Column(
                children: [
                  // Search bar
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        labelText: 'Buscar por nome do paciente',
                        hintText: 'Digite o nome...',
                        prefixIcon: const Icon(Icons.search),
                        suffixIcon: searchValue.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.clear),
                                onPressed: () {
                                  _searchController.clear();
                                },
                              )
                            : null,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),

                  // Results count
                  if (allProntuarios.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        children: [
                          Text(
                            '${prontuarios.length} de ${allProntuarios.length} prontuários',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),

                  const SizedBox(height: 8),

                  // List
                  if (prontuarios.isEmpty && searchValue.isNotEmpty)
                    Expanded(
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.search_off,
                              size: 64,
                              color: Colors.grey,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Nenhum prontuário encontrado',
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'para "$searchValue"',
                              style: TextStyle(
                                color: Colors.grey[500],
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  else if (prontuarios.isEmpty)
                    Expanded(
                      child: Center(
                        child: Text('Nenhum prontuário encontrado'),
                      ),
                    )
                  else
                    Expanded(
                      child: ListView.builder(
                        itemCount: prontuarios.length,
                        itemBuilder: (context, index) {
                          final p = prontuarios[index];
                          return ListTile(
                            title: Text(p.paciente),
                            subtitle: Text(p.descricao),
                            onTap: () async {
                              final updated = await Navigator.push(context, MaterialPageRoute(builder: (_) => FormularioProntuarioScreen(prontuario: p)));
                            },
                            trailing: IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () async {
                                try {
                                  await firestoreService.deletarProntuario(p.id!);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('Prontuário de ${p.paciente} excluído')),
                                  );
                                } catch (e) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('Erro ao excluir: $e')),
                                  );
                                }
                              }
                            ),
                          );
                        },
                      ),
                    ),
                ],
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
