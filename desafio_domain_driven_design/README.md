# To-Do List com Domain-Driven Design e Provider

Aplicativo Flutter de gerenciamento de tarefas usando arquitetura DDD e Provider para gerenciamento de estado.

---

## O que é Domain-Driven Design (DDD)?

DDD é uma forma de organizar o código em camadas, onde cada camada tem uma responsabilidade específica. Isso torna o código mais organizado e fácil de manter.

### As Três Camadas

```
┌─────────────────────────────────┐
│   PRESENTATION                  │  <- Telas e Interface
├─────────────────────────────────┤
│   DOMAIN                        │  <- Regras de Negócio
├─────────────────────────────────┤
│   DATA                          │  <- Acesso aos Dados
└─────────────────────────────────┘
```

**DOMAIN (Domínio)** - O coração da aplicação
- **Entities**: O que é uma tarefa (Todo)
- **Use Cases**: O que o app pode fazer (adicionar, listar, atualizar, deletar)
- **Repository Interface**: Como acessar os dados (apenas o contrato)

**DATA (Dados)** - Como salvar e recuperar dados
- **Repository Implementation**: Implementação real (neste caso, em memória)

**PRESENTATION (Apresentação)** - O que o usuário vê
- **Pages**: As telas
- **Provider**: Gerencia o estado e conecta a UI com o Domain

---

## O que é Provider?

Provider é uma solução de gerenciamento de estado. Ele permite que a interface reaja automaticamente quando os dados mudam.

### Como funciona?

```dart
// O Provider guarda os dados
class TodoProvider extends ChangeNotifier {
  List<Todo> _todos = [];
  
  Future<void> addTodo(String title) async {
    await addTodoUseCase(newTodo);
    notifyListeners(); // Avisa a UI para atualizar
  }
}

// A UI observa o Provider
Consumer<TodoProvider>(
  builder: (context, provider, child) {
    return ListView.builder(
      itemCount: provider.todos.length, // Atualiza automaticamente
    );
  },
)
```

**Por que usar Provider?**
- A UI atualiza sozinha quando os dados mudam
- Separa a lógica da interface
- Simples de entender e usar

---

## Estrutura do Projeto

```
lib/
├── features/todo/
│   ├── domain/                      (Regras de Negócio)
│   │   ├── entities/todo.dart
│   │   ├── repositories/todo_repository.dart (interface)
│   │   └── usecases/
│   │       ├── getTodos_usecase.dart
│   │       ├── addTodo_usecase.dart
│   │       ├── updateTodo_usecase.dart
│   │       └── deleteTodo_usecase.dart
│   │
│   ├── data/                        (Acesso aos Dados)
│   │   └── repositories/todo_repository.dart (implementação)
│   │
│   └── presentation/                (Interface)
│       ├── pages/todo_page.dart
│       └── providers/todo_provider.dart
│
└── main.dart
```

---

## Fluxo de Dados

Quando o usuário adiciona uma tarefa:

```
1. Usuário clica em "Adicionar"
         ↓
2. UI chama o Provider
   provider.addTodo("Estudar Flutter")
         ↓
3. Provider chama o Use Case
   addTodoUseCase(newTodo)
         ↓
4. Use Case chama o Repository
   repository.addTodo(todo)
         ↓
5. Repository salva (em memória)
         ↓
6. Provider notifica: notifyListeners()
         ↓
7. UI atualiza automaticamente
```

---

## Exemplo Prático

### 1. Entity (Domain)
```dart
class Todo {
  final String id;
  final String title;
  bool isCompleted;
  
  Todo({required this.id, required this.title, this.isCompleted = false});
}
```

### 2. Use Case (Domain)
```dart
class AddTodoUseCase {
  final TodoRepository repository;
  
  Future<void> call(Todo todo) async {
    return await repository.addTodo(todo);
  }
}
```

### 3. Repository (Data)
```dart
class TodoRepositoryImpl implements TodoRepository {
  final List<Todo> _todos = [];
  
  @override
  Future<void> addTodo(Todo todo) async {
    _todos.add(todo);
  }
}
```

### 4. Provider (Presentation)
```dart
class TodoProvider extends ChangeNotifier {
  List<Todo> _todos = [];
  
  Future<void> addTodo(String title) async {
    final newTodo = Todo(id: DateTime.now().toString(), title: title);
    await addTodoUseCase(newTodo);
    await loadTodos();
    notifyListeners(); // UI atualiza
  }
}
```

### 5. UI (Presentation)
```dart
Consumer<TodoProvider>(
  builder: (context, provider, child) {
    return ListView.builder(
      itemCount: provider.todos.length,
      itemBuilder: (context, index) {
        return ListTile(title: Text(provider.todos[index].title));
      },
    );
  },
)
```

---

## Validações

O Provider valida o título das tarefas:
- Não pode estar vazio
- Mínimo de 3 caracteres
- Máximo de 100 caracteres
- Sem caracteres especiais: `< > { } [ ] \ /`

---

## Como Executar

```bash
flutter pub get
flutter run
```

---

## Benefícios desta Arquitetura

**Organização**: Fácil encontrar onde está cada coisa

**Manutenção**: Mudanças em uma camada não afetam as outras

**Testes**: Cada parte pode ser testada separadamente

**Escalabilidade**: Fácil adicionar novas funcionalidades

---

## Conceitos Importantes

**SOLID**: Cada classe tem uma responsabilidade única

**Clean Architecture**: Regras de negócio separadas da UI e dos dados

**Separation of Concerns**: Cada camada cuida da sua parte

---

Desenvolvido por Marco | GitHub: @Emanuelprime

Domain-Driven Design é uma abordagem de arquitetura de software que coloca o domínio do negócio no centro do desenvolvimento. Em vez de pensar primeiro em bancos de dados ou interfaces, pensamos primeiro nas regras de negócio e no que o sistema realmente faz.

A ideia principal é organizar o código em camadas bem definidas, onde cada camada tem uma responsabilidade específica e não se mistura com as outras. Isso torna o código mais organizado, mais fácil de entender e de dar manutenção.

### As Três Camadas do DDD

```
┌─────────────────────────────────┐
│   PRESENTATION (Apresentação)   │  ← UI, Widgets, Provider
├─────────────────────────────────┤
│      DOMAIN (Domínio)           │  ← Regras de Negócio, Entities, Use Cases
├─────────────────────────────────┤
│        DATA (Dados)             │  ← Repositórios, Fontes de Dados
└─────────────────────────────────┘
```

#### 1. **Domain Layer** - O Coração da Aplicação
- **Entities**: Modelos do negócio (`Todo`)
- **Use Cases**: Ações que o sistema pode fazer
  - `GetTodosUseCase` - Buscar todas as tarefas
  - `AddTodoUseCase` - Adicionar nova tarefa
  - `UpdateTodoUseCase` - Atualizar tarefa
  - `DeleteTodoUseCase` - Deletar tarefa
- **Repositories (Interface)**: Contratos de como acessar os dados

#### 2. **Data Layer** - Acesso aos Dados
- **Repository Implementation**: Implementação real dos repositórios
- **Data Sources**: De onde vêm os dados (banco de dados, API, memória)

#### 3. **Presentation Layer** - Interface com o Usuário
- **Pages**: Telas do app
- **Providers**: Gerenciamento de estado
- **Widgets**: Componentes visuais

---

## O que é Provider e ChangeNotifier?

Provider é uma solução de gerenciamento de estado recomendada pela equipe do Flutter. Ele resolve um problema comum: como fazer a interface do usuário reagir automaticamente quando os dados mudam?

Imagine que você tem uma lista de tarefas. Quando você adiciona uma nova tarefa, a tela precisa se atualizar para mostrar essa nova tarefa. O Provider facilita isso usando o padrão Observer, onde a UI "observa" os dados e se atualiza automaticamente quando eles mudam.

### Como o Provider Funciona na Prática

```dart
// Passo 1: O TodoProvider estende ChangeNotifier
class TodoProvider extends ChangeNotifier {
  List<Todo> _todos = [];
  
  // Passo 2: Quando os dados mudam, chamamos notifyListeners()
  Future<void> addTodo(String title) async {
    await addTodoUseCase(newTodo);
    await loadTodos();
    notifyListeners(); // Isso avisa a UI para se atualizar
  }
}

// Passo 3: Na UI, usamos Consumer para "observar" as mudanças
Consumer<TodoProvider>(
  builder: (context, todoProvider, child) {
    return ListView.builder(
      itemCount: todoProvider.todos.length,
      // Quando notifyListeners() é chamado, este builder é executado novamente
    );
  },
)
```

O fluxo é simples:
1. O Provider guarda os dados (a lista de tarefas)
2. Quando algo muda (adiciona, remove, atualiza), chamamos `notifyListeners()`
3. Todos os widgets que estão "observando" (usando Consumer) se reconstroem automaticamente com os novos dados

### Por que usar Provider?

**Reatividade**: A interface atualiza automaticamente quando os dados mudam, sem precisar chamar `setState()` manualmente.

**Simplicidade**: É mais simples que outras soluções como BLoC ou MobX, mas poderoso o suficiente para a maioria dos casos.

**Eficiência**: Apenas os widgets que realmente precisam ser atualizados são reconstruídos, economizando performance.

**Separação de Responsabilidades**: A lógica de negócio fica separada da interface, tornando o código mais organizado e testável.  

---

## Estrutura do Projeto

```
lib/
├── features/todo/
│   ├── domain/                          (Camada de Domínio)
│   │   ├── entities/
│   │   │   └── todo.dart               - Entidade Todo
│   │   ├── repositories/
│   │   │   └── todo_repository.dart    - Interface do repositório
│   │   └── usecases/
│   │       ├── getTodos_usecase.dart   - Buscar tarefas
│   │       ├── addTodo_usecase.dart    - Adicionar tarefa
│   │       ├── updateTodo_usecase.dart - Atualizar tarefa
│   │       └── deleteTodo_usecase.dart - Deletar tarefa
│   │
│   ├── data/                            (Camada de Dados)
│   │   └── repositories/
│   │       └── todo_repository.dart    - Implementação do repositório
│   │
│   └── presentation/                    (Camada de Apresentação)
│       ├── pages/
│       │   └── todo_page.dart          - Tela principal
│       └── providers/
│           └── todo_provider.dart      - Gerenciador de estado
│
└── main.dart                            - Configuração inicial e injeção de dependências
```

---

## Como os Dados Fluem pela Aplicação

Vamos acompanhar o que acontece quando o usuário clica no botão para adicionar uma nova tarefa:

```
1. Usuário clica no botão "Adicionar"
         ↓
2. A interface (TodoPage) chama o Provider
   context.read<TodoProvider>().addTodo("Estudar Flutter")
         ↓
3. O Provider chama o Use Case correspondente
   await addTodoUseCase(newTodo)
         ↓
4. O Use Case executa a regra de negócio e chama o Repository
   await repository.addTodo(todo)
         ↓
5. O Repository salva o dado (neste caso, em memória)
   _todos.add(todo)
         ↓
6. O Provider recarrega os dados e notifica os observadores
   await loadTodos()
   notifyListeners()
         ↓
7. Todos os Consumer<TodoProvider> são notificados
         ↓
8. A UI se reconstrói e mostra a nova tarefa
```

Este fluxo garante que a regra de negócio (Use Case) está separada de como os dados são salvos (Repository) e de como são exibidos (UI). Isso significa que podemos trocar qualquer uma dessas partes sem afetar as outras.

---

## Exemplo Prático: Implementação Completa de uma Funcionalidade

Vamos ver como a funcionalidade de adicionar uma tarefa está implementada em cada camada:

### Passo 1: Definir a Entidade (Domain Layer)
Primeiro, definimos o que é uma tarefa no domínio da aplicação:

```dart
class Todo {
  final String id;
  final String title;
  bool isCompleted;
  
  Todo({
    required this.id, 
    required this.title, 
    this.isCompleted = false
  });
}
```

Esta é uma classe simples que representa uma tarefa. Note que não há nenhuma lógica de banco de dados ou interface aqui, apenas a estrutura pura do que é uma tarefa.

### Passo 2: Criar o Use Case (Domain Layer)
O Use Case define a ação de adicionar uma tarefa:

```dart
class AddTodoUseCase {
  final TodoRepository repository;
  
  AddTodoUseCase(this.repository);
  
  Future<void> call(Todo todo) async {
    // Aqui poderíamos adicionar validações ou regras de negócio
    return await repository.addTodo(todo);
  }
}
```

O Use Case não sabe COMO a tarefa será salva, apenas sabe que precisa ser salva. Isso é importante porque mantém as regras de negócio independentes da implementação técnica.

### Passo 3: Implementar o Repository (Data Layer)
Agora implementamos de fato onde e como os dados são salvos:

```dart
class TodoRepositoryImpl implements TodoRepository {
  final List<Todo> _todos = [];
  
  @override
  Future<void> addTodo(Todo todo) async {
    _todos.add(todo);
    // Aqui está em memória, mas poderia ser:
    // await database.insert('todos', todo.toJson());
    // ou await api.post('/todos', todo.toJson());
  }
}
```

O Repository é a única camada que sabe como os dados são realmente armazenados. Se quisermos mudar de memória para SQLite, só precisamos modificar esta classe.

### Passo 4: Criar o Provider (Presentation Layer)
O Provider gerencia o estado e faz a ponte entre a UI e os Use Cases:

```dart
class TodoProvider extends ChangeNotifier {
  final AddTodoUseCase addTodoUseCase;
  final GetTodosUseCase getTodosUseCase;
  
  List<Todo> _todos = [];
  List<Todo> get todos => _todos;
  
  Future<void> addTodo(String title) async {
    // Validação do título
    final validationError = validateTitle(title);
    if (validationError != null) {
      _error = validationError;
      notifyListeners();
      return;
    }
    
    // Criar a nova tarefa
    final newTodo = Todo(
      id: DateTime.now().toString(), 
      title: title.trim()
    );
    
    // Chamar o use case para adicionar
    await addTodoUseCase(newTodo);
    
    // Recarregar a lista
    await loadTodos();
    
    // Notificar a UI para atualizar
    notifyListeners();
  }
  
  Future<void> loadTodos() async {
    _todos = await getTodosUseCase();
  }
}
```

O Provider contém a lógica de apresentação (validação, loading states, etc.) mas delega as operações de dados para os Use Cases.

### Passo 5: Construir a Interface (Presentation Layer)
Por fim, a interface exibe os dados e reage às interações do usuário:

```dart
// A UI observa o TodoProvider usando Consumer
Consumer<TodoProvider>(
  builder: (context, provider, child) {
    // Se estiver carregando, mostra um indicador
    if (provider.isLoading) {
      return Center(child: CircularProgressIndicator());
    }
    
    // Mostra a lista de tarefas
    return ListView.builder(
      itemCount: provider.todos.length,
      itemBuilder: (context, index) {
        final todo = provider.todos[index];
        return ListTile(
          title: Text(todo.title),
          leading: Checkbox(
            value: todo.isCompleted,
            onChanged: (value) {
              // Quando o usuário marca/desmarca
              final updatedTodo = todo.copyWith(isCompleted: value);
              provider.updateTodo(updatedTodo);
            },
          ),
        );
      },
    );
  },
)

// Botão para adicionar nova tarefa
FloatingActionButton(
  onPressed: () {
    // Chama o método do provider
    context.read<TodoProvider>().addTodo(titleController.text);
  },
  child: Icon(Icons.add),
)
```

---

## Validações Implementadas

Para garantir a qualidade dos dados, o `TodoProvider` implementa validações antes de adicionar ou atualizar uma tarefa:

**Título não pode estar vazio**: Verifica se o usuário realmente digitou algo

**Tamanho mínimo de 3 caracteres**: Evita títulos muito curtos como "aa"

**Tamanho máximo de 100 caracteres**: Mantém os títulos concisos

**Caracteres especiais proibidos**: Não permite caracteres que poderiam causar problemas: `< > { } [ ] \ /`

Exemplo de validação no código:

```dart
String? validateTitle(String? title) {
  if (title == null || title.trim().isEmpty) {
    return 'O título não pode estar vazio';
  }
  
  if (title.trim().length < 3) {
    return 'O título deve ter pelo menos 3 caracteres';
  }
  
  if (title.trim().length > 100) {
    return 'O título deve ter no máximo 100 caracteres';
  }
  
  final invalidChars = RegExp(r'[<>{}[\]\\\/]');
  if (invalidChars.hasMatch(title)) {
    return 'O título contém caracteres inválidos';
  }
  
  return null; // Título válido
}
```

---

## Como Executar o Projeto

Para rodar este projeto na sua máquina:

```bash
# Instalar as dependências do projeto
flutter pub get

# Executar o aplicativo
flutter run
```

---

## Conceitos de Arquitetura Aplicados

### Princípios SOLID

O projeto segue os cinco princípios SOLID de programação orientada a objetos:

**Single Responsibility (Responsabilidade Única)**: Cada classe tem apenas uma razão para mudar. Por exemplo, o `AddTodoUseCase` só adiciona tarefas, o `TodoRepository` só acessa dados.

**Open/Closed (Aberto/Fechado)**: O código está aberto para extensão mas fechado para modificação. Podemos adicionar novos use cases sem alterar os existentes.

**Liskov Substitution (Substituição de Liskov)**: Podemos substituir a implementação do repositório por outra que implemente a mesma interface, sem quebrar o código.

**Interface Segregation (Segregação de Interface)**: As interfaces são específicas e enxutas. Cada repository tem apenas os métodos necessários para aquele domínio.

**Dependency Inversion (Inversão de Dependência)**: As camadas superiores dependem de abstrações (interfaces), não de implementações concretas. O Use Case depende da interface `TodoRepository`, não da implementação `TodoRepositoryImpl`.

### Clean Architecture

O projeto também segue os princípios de Clean Architecture:

**Independência de Frameworks**: A lógica de negócio não depende do Flutter ou de qualquer biblioteca externa.

**Testabilidade**: Cada camada pode ser testada isoladamente. Podemos testar os Use Cases sem precisar de banco de dados ou interface.

**Independência de UI**: Podemos trocar a interface completamente (usar outro framework, por exemplo) sem alterar as regras de negócio.

**Independência de Banco de Dados**: Podemos trocar a forma de armazenamento (memória, SQLite, Firebase) sem afetar o resto da aplicação.

---

## Benefícios Desta Arquitetura

### Para Manutenção

Quando você precisa fazer uma mudança, é fácil saber onde mexer:
- Mudança na regra de negócio? Vá para o Use Case
- Mudança em como salvar dados? Vá para o Repository
- Mudança visual? Vá para a Page/Widget

### Para Testes

Cada camada pode ser testada independentemente:
- Testes de Use Cases não precisam de banco de dados
- Testes de Repository não precisam de interface
- Testes de UI podem usar mocks dos Use Cases

### Para Crescimento

Adicionar novas funcionalidades é simples:
- Nova funcionalidade? Crie um novo Use Case
- Nova fonte de dados? Implemente um novo Repository
- Nova tela? Crie uma nova Page com seu Provider

### Para Trabalho em Equipe

Diferentes pessoas podem trabalhar em diferentes camadas sem conflitos:
- Um desenvolvedor trabalha nos Use Cases
- Outro implementa a persistência de dados
- Outro cuida da interface

---

## Pontos Importantes para Apresentação

**Por que separar em camadas?**
Para que mudanças em uma parte do código não afetem outras partes. Se decidirmos trocar de SQLite para Firebase, só mudamos o Repository, o resto continua igual.

**Por que usar Use Cases?**
Porque cada ação do usuário é uma operação de negócio específica. Isso facilita manutenção e testes.

**Por que Provider ao invés de setState?**
Provider gerencia o estado de forma centralizada e eficiente. Com setState, teríamos que passar callbacks por vários níveis de widgets.

**Diferença entre Repository Interface e Implementation?**
A interface define "o que" pode ser feito (contrato). A implementação define "como" é feito (SQLite, API, etc).

---

Desenvolvido por Marco | GitHub: @Emanuelprime
