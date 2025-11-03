import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'features/todo/data/repositories/todo_repository.dart';
import 'features/todo/domain/usecases/addTodo_usecase.dart';
import 'features/todo/domain/usecases/deleteTodo.usecase.dart';
import 'features/todo/domain/usecases/getTodos_usecase.dart';
import 'features/todo/domain/usecases/updateTodo_usecase.dart';
import 'features/todo/presentation/pages/todo_page.dart';
import 'features/todo/presentation/providers/todo_provider.dart';

void main() {
  // criando dependencias
  final repository = TodoRepositoryImpl();

  // criando usecases
  final getTodosUseCase = GetTodosUseCase(repository);
  final addTodoUseCase = AddTodoUseCase(repository);
  final updateTodoUseCase = UpdateTodoUseCase(repository);
  final deleteTodoUseCase = DeleteTodoUseCase(repository);

  runApp(
    ChangeNotifierProvider(
      create: (_) => TodoProvider(
        getTodosUseCase: getTodosUseCase,
        addTodoUseCase: addTodoUseCase,
        updateTodoUseCase: updateTodoUseCase,
        deleteTodoUseCase: deleteTodoUseCase,
      ),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App de To-Do List com DDD',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const TodoPage(),
    );
  }
}
