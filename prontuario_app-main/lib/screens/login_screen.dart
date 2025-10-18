import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'prontuario_list_screen.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _loading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _loading = true);

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Login realizado com sucesso!')),
        );

        // Navigate to main list screen
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => ProntuarioListScreen()),
          (route) => false,
        );
      }
    } on FirebaseAuthException catch (e) {
      String message = 'Erro ao autenticar.';
      if (e.code == 'user-not-found') {
        message = 'Usuário não encontrado.';
      } else if (e.code == 'wrong-password') {
        message = 'Senha incorreta.';
      } else if (e.code == 'invalid-email') {
        message = 'E-mail inválido.';
      } else if (e.code == 'user-disabled') {
        message = 'Conta desabilitada.';
      } else if (e.code == 'invalid-credential') {
        message = 'E-mail ou senha incorretos.';
      }

      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(message)));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Erro: ${e.toString()}')));
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login'), backgroundColor: Colors.green),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),
              const Icon(Icons.account_circle, size: 80, color: Colors.green),
              const SizedBox(height: 20),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'E-mail',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.email),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return 'Informe o e-mail';
                  final email = v.trim();
                  if (!RegExp(
                    r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}",
                  ).hasMatch(email)) {
                    return 'E-mail inválido';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(
                  labelText: 'Senha',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.lock),
                ),
                obscureText: true,
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Informe a senha';
                  if (v.length < 6)
                    return 'Senha precisa ter ao menos 6 caracteres';
                  return null;
                },
              ),
              const SizedBox(height: 24),
              _loading
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      onPressed: _login,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text(
                        'Entrar',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const RegisterScreen()),
                ),
                child: const Text('Não tem conta? Cadastrar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
