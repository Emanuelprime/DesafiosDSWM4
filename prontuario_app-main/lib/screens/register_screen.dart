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

      // Navigate to main list screen replacing the stack
      if (mounted) {
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
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message)));
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Erro: ${e.toString()}')));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Cadastro')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 8),
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Nome'),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Informe o nome' : null,
              ),
              SizedBox(height: 12),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'E-mail'),
                keyboardType: TextInputType.emailAddress,
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return 'Informe o e-mail';
                  final email = v.trim();
                  if (!RegExp(
                    r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}",
                  ).hasMatch(email))
                    return 'E-mail inválido';
                  return null;
                },
              ),
              SizedBox(height: 12),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(labelText: 'Senha'),
                obscureText: true,
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Informe a senha';
                  if (v.length < 6)
                    return 'Senha precisa ter ao menos 6 caracteres';
                  return null;
                },
              ),
              SizedBox(height: 12),
              TextFormField(
                controller: _confirmController,
                decoration: InputDecoration(labelText: 'Confirmar senha'),
                obscureText: true,
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Confirme a senha';
                  if (v != _passwordController.text)
                    return 'Senhas não conferem';
                  return null;
                },
              ),
              SizedBox(height: 20),
              _loading
                  ? Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      onPressed: _register,
                      child: Text('Cadastrar'),
                    ),
              SizedBox(height: 12),
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('Já tem conta? Fazer login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
