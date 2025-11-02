import '../../domain/entities/todo.dart';
import '../../domain/repositories/todo_repository.dart';

// implementacao concreta daquela interface de repositorio no domain/repositories
class TodoRepositoryImpl implements TodoRepository {
  final List<Todo> _todos = [];

  // pegar todos
  @override     // uso do override pra sinalizar que estamos usndo a implementacao de um metodo
  Future<List<Todo>> getTodos() async {
    return _todos;
  }

  // adicionar todos
  @override
  Future<void> addTodo(Todo todo) async {
    _todos.add(todo);
  }

  // atualizar todos
  @override
  Future<void> updateTodo(Todo todo) async {
    final index = _todos.indexWhere((t) => t.id == todo.id);
    if (index >= 0) {
      _todos[index] = todo;
    }
  }

  // apagar todos
  @override
  Future<void> deleteTodo(String id) async {
    _todos.removeWhere((todo) => todo.id == id);
  }
}