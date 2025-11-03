# To-Do List com Provider

## Como Utilizei o Provider neste Projeto

### 1. Instalação da Dependência

Adicionei o pacote `provider` no `pubspec.yaml`:

```yaml
dependencies:
  provider: ^6.1.1
```

### 2. Criação do TodoProvider

Criei a classe `TodoProvider` em `lib/features/todo/presentation/providers/todo_provider.dart`:

```dart
class TodoProvider extends ChangeNotifier {
  final GetTodosUseCase getTodosUseCase;
  final AddTodoUseCase addTodoUseCase;
  final UpdateTodoUseCase updateTodoUseCase;
  final DeleteTodoUseCase deleteTodoUseCase;

  List<Todo> _todos = [];
  bool _isLoading = false;
  String? _error;

  List<Todo> get todos => _todos;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> addTodo(String title) async {
    final newTodo = Todo(id: DateTime.now().toString(), title: title.trim());
    await addTodoUseCase(newTodo);
    await loadTodos();
    notifyListeners(); // Atualiza a UI
  }

  Future<void> loadTodos() async {
    _isLoading = true;
    notifyListeners();
    
    _todos = await getTodosUseCase();
    _isLoading = false;
    notifyListeners();
  }
}
```

**O que faz**: Gerencia o estado das tarefas e notifica a UI quando algo muda.

### 3. Configuração no main.dart

Envolvi o app com `ChangeNotifierProvider`:

```dart
void main() {
  final repository = TodoRepositoryImpl();
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
```

**O que faz**: Disponibiliza o `TodoProvider` para toda a árvore de widgets.

### 4. Uso na Interface (TodoPage)

Usei `Consumer` para observar as mudanças:

```dart
class TodoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<TodoProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return Center(child: CircularProgressIndicator());
          }

          return ListView.builder(
            itemCount: provider.todos.length,
            itemBuilder: (context, index) {
              final todo = provider.todos[index];
              return ListTile(
                title: Text(todo.title),
                leading: Checkbox(
                  value: todo.isCompleted,
                  onChanged: (value) {
                    final updatedTodo = todo.copyWith(isCompleted: value);
                    provider.updateTodo(updatedTodo);
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Chama o provider para adicionar tarefa
          context.read<TodoProvider>().addTodo(titleController.text);
        },
      ),
    );
  }
}
```

**O que faz**: 
- `Consumer` reconstrói apenas esta parte da UI quando `notifyListeners()` é chamado
- `context.read<TodoProvider>()` acessa o provider para chamar métodos

---

## Resumo: Como o Provider Funciona

1. **TodoProvider** guarda os dados (lista de tarefas)
2. Quando dados mudam, chamo `notifyListeners()`
3. Todos os `Consumer<TodoProvider>` são notificados
4. A UI se reconstrói automaticamente

---

## Onde Utilizei

- **Arquivo do Provider**: `lib/features/todo/presentation/providers/todo_provider.dart`
- **Configuração**: `lib/main.dart`
- **Uso na UI**: `lib/features/todo/presentation/pages/todo_page.dart`

---

Desenvolvido por Marco
