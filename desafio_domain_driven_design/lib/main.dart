// lib/main.dart (CÓDIGO INICIAL A SER REFATORADO)
import 'package:flutter/material.dart';

class TodoItem {
  final String title;
  bool isCompleted;

  TodoItem(this.title, {this.isCompleted = false});
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'DDD Refactor Challenge',
      home: TodoListScreen(),
    );
  }
}

class TodoListScreen extends StatefulWidget {
  const TodoListScreen({super.key});

  @override
  State<TodoListScreen> createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
  final List<TodoItem> _todos = [];
  final TextEditingController _controller = TextEditingController();

  // Lógica de "Serviço/Infraestrutura"
  void _loadTodosFromStorage() {
    // Simula o carregamento de dados (Infraestrutura)
    setState(() {
      _todos.add(TodoItem('Comprar leite', isCompleted: false));
      _todos.add(TodoItem('Estudar DDD', isCompleted: true));
    });
  }

  // Lógica de Negócio (Domínio)
  void _addTodo() {
    final title = _controller.text.trim();
    if (title.isNotEmpty && title.length < 50) {
      // Regra de Negócio: limite de 50 caracteres
      setState(() {
        _todos.add(TodoItem(title));
        _controller.clear();
      });
    } else if (title.length >= 50) {
      // Simulação de erro/feedback da UI

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('A tarefa é muito longa!')));
    }
  }

  // Lógica de Negócio (Domínio)
  void _toggleTodo(int index) {
    setState(() {
      _todos[index].isCompleted = !_todos[index].isCompleted;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadTodosFromStorage();
  }

  @override
  Widget build(BuildContext context) {
    // Lógica de Apresentação/UI
    return Scaffold(
      appBar: AppBar(title: const Text('Minhas Tarefas (God Widget)')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(labelText: 'Nova Tarefa'),
                  ),
                ),
                ElevatedButton(
                  onPressed: _addTodo,
                  child: const Text('Adicionar'),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _todos.length,
              itemBuilder: (context, index) {
                final todo = _todos[index];
                return ListTile(
                  title: Text(
                    todo.title,
                    style: TextStyle(
                      decoration: todo.isCompleted
                          ? TextDecoration.lineThrough
                          : null,
                    ),
                  ),
                  trailing: Checkbox(
                    value: todo.isCompleted,
                    onChanged: (_) => _toggleTodo(index),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
