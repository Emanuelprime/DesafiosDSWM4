# Sistema de Autenticação - Firebase Auth



#### 1. **Página de Login** (`lib/screens/login_screen.dart`)
- Autenticação com Firebase Auth usando e-mail e senha
- Validação de campos (e-mail válido, senha mínima de 6 caracteres)
- Feedback visual com loading e mensagens de erro
- Tratamento de erros do Firebase:
  - Usuário não encontrado
  - Senha incorreta
  - E-mail inválido
  - Conta desabilitada
- Botão para navegar para a tela de cadastro

#### 2. **Página de Registro** (`lib/screens/register_screen.dart`)
- Cadastro de novos usuários com Firebase Auth
- Campos: Nome, E-mail, Senha e Confirmação de senha
- Validação completa:
  - Nome obrigatório
  - E-mail válido com regex
  - Senha mínima de 6 caracteres
  - Confirmação de senha
- Atualização do displayName do usuário
- Tratamento de erros:
  - E-mail já em uso
  - E-mail inválido
  - Senha fraca
- Botão para voltar ao login

#### 3. **Sistema de Autenticação** (`lib/main.dart`)
- Verificação automática do estado de autenticação
- StreamBuilder conectado ao `authStateChanges()` do Firebase
- Redirecionamento automático:
  - Se logado → `ProntuarioListScreen`
  - Se não logado → `LoginScreen`
- Loading enquanto verifica o estado

#### 4. **Botão de Logout** (`lib/screens/prontuario_list_screen.dart`)
- Ícone de logout no AppBar
- Função `FirebaseAuth.instance.signOut()`
- Feedback com SnackBar após logout
- Redirecionamento automático para tela de login

### 🎨 Estilo Consistente

Ambas as páginas seguem o mesmo padrão visual:
- AppBar verde com título
- Ícones temáticos (account_circle para login, person_add para registro)
- Campos de formulário com borda e ícones prefix
- Botões principais em verde
- CircularProgressIndicator durante operações
- TextButtons para navegação secundária
- Padding e espaçamento consistentes

### 🔧 Dependências Adicionadas

```yaml
dependencies:
  firebase_core: ^2.32.0
  firebase_auth: ^4.16.0
  cloud_firestore: ^4.7.3
```

## 🚀 Como Testar

1. Execute o aplicativo:
```powershell
cd 'c:\Users\marco\Desktop\VSCODE\Desafios\DesafiosDSWM4\prontuario_app-main'
flutter run
```

2. Fluxo de teste:
   - Aplicativo abre na tela de login
   - Clique em "Não tem conta? Cadastrar"
   - Preencha os dados e crie uma conta
   - Será redirecionado para a lista de prontuários
   - Clique no ícone de logout (canto superior direito)
   - Faça login novamente com as credenciais criadas

## 📋 Funcionalidades de Segurança

- Senhas nunca são exibidas (obscureText: true)
- Validação de e-mail com regex
- Senha mínima de 6 caracteres
- Tratamento de todos os erros comuns do Firebase Auth
- Verificação de autenticação em tempo real
- Navegação segura com verificação de `mounted`
