import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'firebase_options.dart';
import 'screens/login_screen.dart';
import 'screens/prontuario_list_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // só inicializa se ainda não existir
  try {
    if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
    } else {
      Firebase.app();
    }
    final opts = Firebase.apps.first.options;
    print('Firebase initialized. projectId=${opts.projectId}');
  } catch (e, st) {
    print('Firebase init error: $e\n$st');
  }

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Prontuário Eletrônico',
      theme: ThemeData(
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      debugShowCheckedModeBanner: false,
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          // mostrar loading enquanto ainda faz o carregamento do firebase e validações de login
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          // se o usuario esta logado no sistema, exibe a lista de prontuarios
          if (snapshot.hasData) {
            return const ProntuarioListScreen();
          }

          // senao, volta pra tela de login
          return const LoginScreen();
        },
      ),
    );
  }
}
