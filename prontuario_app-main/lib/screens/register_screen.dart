import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'prontuario_list_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmController = TextEditingController();
  bool _loading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _loading = true);

    try {
      final credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
            email: _emailController.text.trim(),
            password: _passwordController.text,
          );

      // Update display name
      await credential.user?.updateDisplayName(_nameController.text.trim());

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Cadastro realizado com sucesso!')),
        );

        // Navigate to main list screen
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => ProntuarioListScreen()),
          (route) => false,
        );
      }
    } on FirebaseAuthException catch (e) {
      String message = 'Erro ao cadastrar usuário.';
      if (e.code == 'email-already-in-use') {
        message = 'O e-mail já está em uso.';
      } else if (e.code == 'invalid-email') {
        message = 'E-mail inválido.';
      } else if (e.code == 'weak-password') {
        message = 'Senha muito fraca (mínimo 6 caracteres).';
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
      appBar: AppBar(
        title: const Text('Cadastro'),
        backgroundColor: Colors.green,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),
              const Icon(Icons.person_add, size: 80, color: Colors.green),
              const SizedBox(height: 20),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Nome',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Informe o nome' : null,
              ),
              const SizedBox(height: 16),
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
              const SizedBox(height: 16),
              TextFormField(
                controller: _confirmController,
                decoration: const InputDecoration(
                  labelText: 'Confirmar senha',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.lock_outline),
                ),
                obscureText: true,
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Confirme a senha';
                  if (v != _passwordController.text)
                    return 'Senhas não conferem';
                  return null;
                },
              ),
              const SizedBox(height: 24),
              _loading
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      onPressed: _register,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text(
                        'Cadastrar',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Já tem conta? Fazer login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
