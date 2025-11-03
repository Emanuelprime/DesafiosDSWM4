import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/todo_provider.dart';

class TodoPage extends StatelessWidget {
  const TodoPage({super.key});

  Future<void> _showAddTodoDialog(BuildContext context) async {
    final textController = TextEditingController();

    return showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Nova To-Do'),
          content: TextField(
            controller: textController,
            decoration: const InputDecoration(hintText: 'Digite a tarefa'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () async {
                if (textController.text.isNotEmpty) {
                  await context.read<TodoProvider>().addTodo(
                    textController.text,
                  );
                  textController.dispose();
                  Navigator.pop(dialogContext);
                }
              },
              child: const Text('Adicionar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Lista de Afazeres')),
      body: Consumer<TodoProvider>(
        builder: (context, todoProvider, child) {
          if (todoProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (todoProvider.error != null) {
            return Center(
              child: Text(
                'Erro: ${todoProvider.error}',
                style: const TextStyle(color: Colors.red),
              ),
            );
          }

          if (todoProvider.todos.isEmpty) {
            return const Center(child: Text('Nenhuma tarefa adicionada'));
          }

          return ListView.builder(
            itemCount: todoProvider.todos.length,
            itemBuilder: (context, index) {
              final todo = todoProvider.todos[index];
              return ListTile(
                title: Text(
                  todo.title,
                  style: TextStyle(
                    decoration: todo.isCompleted
                        ? TextDecoration.lineThrough
                        : TextDecoration.none,
                  ),
                ),
                leading: Checkbox(
                  value: todo.isCompleted,
                  onChanged: (value) async {
                    final updatedTodo = todo.copyWith(isCompleted: value);
                    await todoProvider.updateTodo(updatedTodo);
                  },
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () async {
                    await todoProvider.deleteTodo(todo.id);
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddTodoDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }
}
