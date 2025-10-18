import 'package:flutter/material.dart';
import '../models/prontuario.dart';
import '../services/firestore_service.dart';

class FormularioProntuarioScreen extends StatefulWidget {
  final Prontuario? prontuario; // se nao for nulo => modo edicao
  const FormularioProntuarioScreen({Key? key, this.prontuario}) : super(key: key);

  @override
  _FormularioProntuarioScreenState createState() =>
      _FormularioProntuarioScreenState();
}

class _FormularioProntuarioScreenState extends State<FormularioProntuarioScreen> {
  final _formKey = GlobalKey<FormState>();
  final _pacienteController = TextEditingController();
  final _descricaoController = TextEditingController();
  final _service = FirestoreService();

  bool get isEditing => widget.prontuario != null;

  // prevenindo de alterar todo o codigo
  void _salvar() {
    _salvarAsync();
  }

  Future<void> _salvarAsync() async {
    if (!_formKey.currentState!.validate()) return;
    final prontuario = Prontuario(
      id: widget.prontuario?.id,
      paciente: _pacienteController.text,
      descricao: _descricaoController.text,
      data: widget.prontuario?.data ?? DateTime.now(),
    );
    try {
      if (isEditing) {
        await _service.atualizarProntuario(prontuario);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Atualizado')));
      } else {
        await _service.adicionarProntuario(prontuario);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Salvo')));
      }
      Navigator.pop(context, true);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erro: $e')));
    }
  }

  @override
  void initState() {
    super.initState();
    if (isEditing) {
      _pacienteController.text = widget.prontuario!.paciente;
      _descricaoController.text = widget.prontuario!.descricao;
    }
  }

  @override
  void dispose() {
    _pacienteController.dispose();
    _descricaoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(isEditing ? 'Editar Prontuário' : 'Novo Prontuário')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _pacienteController,
                decoration: InputDecoration(labelText: 'Nome do Paciente'),
                validator: (value) => value!.isEmpty ? 'Informe o nome' : null,
              ),
              TextFormField(
                controller: _descricaoController,
                decoration: InputDecoration(labelText: 'Descrição'),
                validator: (value) =>
                    value!.isEmpty ? 'Informe a descrição' : null,
              ),
              SizedBox(height: 20),
              ElevatedButton(onPressed: _salvar, child: Text(isEditing ? 'Atualizar' : 'Salvar')),
            ],
          ),
        ),
      ),
    );
  }
}
