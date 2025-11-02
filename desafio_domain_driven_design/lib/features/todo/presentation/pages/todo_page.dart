import 'package:flutter/material.dart';
import '../../domain/entities/todo.dart';
import '../../domain/usecases/addTodo_usecase.dart';
import '../../domain/usecases/getTodos_usecase.dart';
import '../../domain/usecases/updateTodo_usecase.dart';
import '../../domain/usecases/deleteTodo.usecase.dart';

class TodoPage extends StatefulWidget {
  final GetTodosUseCase getTodosUseCase;
  final AddTodoUseCase addTodoUseCase;
  final UpdateTodoUseCase updateTodoUseCase;
  final DeleteTodoUseCase deleteTodoUseCase;

  const TodoPage({
    Key? key,
    required this.getTodosUseCase,
    required this.addTodoUseCase,
    required this.updateTodoUseCase,
    required this.deleteTodoUseCase,
  }) : super(key: key);

  @override
  State<TodoPage> createState() => _TodoPageState(); 
}

class _TodoPageState extends State<TodoPage> {
  List<Todo> _todos = [];
  final _textController = TextEditingController();

  Future<void> _showAddTodoDialog() async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Nova To-Do'),
          content: TextField(
            controller: _textController,
            decoration: const InputDecoration(hintText: 'Digite a tarefa'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () async {
                if (_textController.text.isNotEmpty) {
                  final newTodo = Todo(
                    id: DateTime.now().toString(),
                    title: _textController.text,
                  );
                  await widget.addTodoUseCase(newTodo);
                  await _loadTodos();
                  _textController.clear();
                  Navigator.pop(context);
                }
              },
              child: const Text('Adicionar'),
            )
          ],
        );
      }
    );
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _loadTodos();
  }

  Future<void> _loadTodos() async {
    final todos = await widget.getTodosUseCase();
    setState(() {
      _todos = todos;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Lista de Afazeres')),
      body: ListView.builder(
        itemCount: _todos.length,
        itemBuilder: (context, index) {
          final todo = _todos[index];
          return ListTile(
            title: Text(todo.title),
            leading: Checkbox(
              value: todo.isCompleted,
              onChanged: (value) async {
                final updatedTodo = todo.copyWith(isCompleted: value);      // uso do metodo de copia para facilitar a modificacao
                await widget.updateTodoUseCase(updatedTodo);                // atualiza o estado da to-do
                await _loadTodos();                                         // recarrega a lista
              }
            ),
            trailing: IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () async {
                await widget.deleteTodoUseCase(todo.id);                    // deleta a to-do
                await _loadTodos();                                         // recarrega a lista
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddTodoDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}