import '../entities/todo.dart';
import '../repositories/todo_repository.dart';

// o que é um usecase?
// um usecase é uma acao que o usuario pode realizar no sistema

// se o usecase é classe abstrata, como que o usecase utiliza o método já implementado?
// na prática estamos usando o código feito no data/repositories só que de forma indireta (atraves da classe abstrata)

// usecase para atualizar uma to-do
class UpdateTodoUseCase {
  final TodoRepository repository;

  UpdateTodoUseCase(this.repository);

  Future<void> call(Todo todo) async {
    await repository.updateTodo(todo);
  }
}