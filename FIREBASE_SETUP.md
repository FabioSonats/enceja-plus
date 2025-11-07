# 🔥 Configuração do Firebase Authentication

## 📋 **Passos para Configurar o Firebase**

### **1. Configurar Projeto no Firebase Console**

1. Acesse [Firebase Console](https://console.firebase.google.com/)
2. Selecione o projeto `vencceja-e8a9c`
3. Vá para **Authentication** > **Sign-in method**

### **2. Ativar Métodos de Login**

#### **E-mail/Senha (Obrigatório)**
- ✅ Ative **E-mail/senha**
- ✅ Ative **Link de email (senha sem senha)** (opcional)

#### **Google (Recomendado)**
- ✅ Ative **Google**
- Configure o **nome do projeto**: `ENCCEJA Plus`
- Configure o **email de suporte**: `seu-email@exemplo.com`

#### **Anônimo (Opcional)**
- ✅ Ative **Anônimo** para usuários que querem testar sem cadastro

### **3. Configurar Aplicativo Android**

1. Vá para **Project Settings** > **General**
2. Clique em **Add app** > **Android**
3. Configure:
   - **Package name**: `com.example.encceja_plus`
   - **App nickname**: `ENCCEJA Plus Android`
   - **SHA-1**: Execute o comando abaixo para obter

#### **Obter SHA-1:**
```bash
# Windows
keytool -list -v -keystore %USERPROFILE%\.android\debug.keystore -alias androiddebugkey -storepass android -keypass android

# macOS/Linux
keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android -keypass android
```

4. Baixe o arquivo `google-services.json`
5. Substitua o arquivo em `android/app/google-services.json`

### **4. Configurar Aplicativo iOS**

1. Vá para **Project Settings** > **General**
2. Clique em **Add app** > **iOS**
3. Configure:
   - **Bundle ID**: `com.example.enccejaPlus`
   - **App nickname**: `ENCCEJA Plus iOS`
4. Baixe o arquivo `GoogleService-Info.plist`
5. Adicione o arquivo em `ios/Runner/GoogleService-Info.plist`

### **5. Configurar Aplicativo Web**

1. Vá para **Project Settings** > **General**
2. Clique em **Add app** > **Web**
3. Configure:
   - **App nickname**: `ENCCEJA Plus Web`
   - **Firebase Hosting**: Não (por enquanto)
4. Copie as configurações para `lib/firebase_options.dart`

### **6. Atualizar firebase_options.dart**

Substitua os valores `YOUR_*` no arquivo `lib/firebase_options.dart`:

```dart
static const FirebaseOptions web = FirebaseOptions(
  apiKey: 'AIzaSyC...', // Sua chave da web
  appId: '1:123456789:web:abc123', // Seu app ID da web
  messagingSenderId: '123456789', // Seu sender ID
  projectId: 'vencceja-e8a9c',
  authDomain: 'vencceja-e8a9c.firebaseapp.com',
  storageBucket: 'vencceja-e8a9c.appspot.com',
);

static const FirebaseOptions android = FirebaseOptions(
  apiKey: 'AIzaSyC...', // Sua chave do Android
  appId: '1:123456789:android:abc123', // Seu app ID do Android
  messagingSenderId: '123456789', // Seu sender ID
  projectId: 'vencceja-e8a9c',
  storageBucket: 'vencceja-e8a9c.appspot.com',
);
```

### **7. Configurar Domínios Autorizados**

1. Vá para **Authentication** > **Settings**
2. Em **Authorized domains**, adicione:
   - `localhost` (para desenvolvimento)
   - Seu domínio de produção (quando tiver)

### **8. Testar a Configuração**

```bash
# Executar o projeto
flutter run -d chrome

# Ou para Android
flutter run -d android
```

## 🎯 **Funcionalidades Implementadas**

### **✅ Login com E-mail/Senha**
- Cadastro de novos usuários
- Login de usuários existentes
- Validação de email e senha
- Mensagens de erro em português

### **✅ Login com Google**
- Autenticação social
- Criação automática de conta
- Dados do perfil sincronizados

### **✅ Login Anônimo**
- Acesso sem cadastro
- Ideal para testes
- Conversão para conta permanente

### **✅ Recuperação de Senha**
- Envio de email de reset
- Interface amigável
- Validação de email

### **✅ Gerenciamento de Sessão**
- Logout seguro
- Redirecionamento automático
- Estado persistente

## 🔧 **Estrutura do Código**

```
lib/
├── data/
│   ├── models/user_model.dart          # Modelo do usuário
│   ├── repositories/auth_repository.dart # Repositório de auth
│   └── services/auth_service.dart      # Serviço Firebase Auth
├── presentation/
│   ├── blocs/auth_bloc.dart           # BLoC de autenticação
│   ├── views/auth/login_screen.dart   # Tela de login
│   └── widgets/auth/                  # Widgets de auth
└── firebase_options.dart              # Configurações Firebase
```

## 🚀 **Próximos Passos**

1. **Configurar Firebase** seguindo os passos acima
2. **Testar autenticação** em diferentes plataformas
3. **Implementar perfil do usuário** com dados do Firestore
4. **Adicionar validação de email** obrigatória
5. **Implementar autenticação multifator** (opcional)

## 📞 **Suporte**

Se encontrar problemas:
1. Verifique se todos os arquivos de configuração estão corretos
2. Confirme se as chaves API estão corretas
3. Teste em diferentes plataformas
4. Verifique os logs do Firebase Console

**Boa sorte com a implementação!** 🎯✨
