import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'screens/prontuario_list_screen.dart'; // Tela principal com lista de prontuários
import 'firebase_options.dart'; //

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Só inicializa se ainda não existir
  if (Firebase.apps.isEmpty) {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } else {
    Firebase.app(); // pega a instância já existente
  }

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Prontuário Eletrônico',
      theme: ThemeData(
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      debugShowCheckedModeBanner: false,
      home: ProntuarioListScreen(), // Tela inicial do app
    );
  }
}
