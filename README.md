# ENCCEJA+ 📚

Um aplicativo Flutter multiplataforma (Web + Mobile) para ajudar pessoas a estudarem para o ENCCEJA com recursos gamificados, acesso a materiais de estudo, cronograma de inscrições e simulados.

## 🚀 Características

- **Gamificação**: Sistema de XP, níveis e conquistas
- **Estudos Interativos**: Lições no estilo Duolingo
- **Simulados**: Testes baseados em provas reais do ENCCEJA
- **Cronograma**: Datas importantes e lembretes
- **Multiplataforma**: Web e Mobile
- **Tema Adaptativo**: Modo claro e escuro

## 🏗️ Arquitetura

- **Frontend**: Flutter 3.24+
- **Arquitetura**: MVVM + SOLID + Clean Code
- **Gerenciamento de Estado**: Flutter BLoC
- **Navegação**: Go Router
- **Tema**: Material 3
- **Design System**: Atomic Design

## 📁 Estrutura do Projeto

```
lib/
├── core/
│   ├── constants/          # Constantes da aplicação
│   ├── errors/            # Tratamento de erros
│   ├── routes/            # Configuração de rotas
│   ├── theme/             # Temas e cores
│   └── utils/             # Utilitários
├── data/
│   ├── datasources/       # Fontes de dados
│   ├── models/           # Modelos de dados
│   └── repositories/      # Repositórios
├── domain/
│   ├── entities/         # Entidades de negócio
│   └── usecases/         # Casos de uso
└── presentation/
    ├── viewmodels/       # BLoCs e ViewModels
    ├── views/           # Telas da aplicação
    ├── widgets/         # Componentes reutilizáveis
    └── animations/      # Animações customizadas
```

## 🎮 Funcionalidades

### ✅ Implementadas
- [x] Estrutura de projeto MVVM + BLoC
- [x] Sistema de autenticação (Email, Google, Anônimo)
- [x] Onboarding gamificado
- [x] Dashboard principal
- [x] Navegação entre telas
- [x] Tema Material 3 (claro/escuro)
- [x] Perfil do usuário
- [x] Jogos de Matemática (Soma e Subtração)
- [x] Jogo de Português (Gramática Básica)
- [x] Sistema de desbloqueio baseado em precisão
- [x] Biblioteca de PDFs organizada por matéria
- [x] Telas para todas as matérias (História, Ciências, Geografia)

### 🚧 Em Desenvolvimento
- [ ] Componentes genéricos para jogos
- [ ] Sistema de estudos gamificado completo
- [ ] Simulados e quizzes
- [ ] Cronograma do ENCCEJA
- [ ] Sistema de conquistas
- [ ] Notificações push
- [ ] Integração com Firebase

## 🛠️ Tecnologias

- **Flutter**: Framework multiplataforma
- **BLoC**: Gerenciamento de estado
- **Go Router**: Navegação
- **Firebase**: Backend (Auth, Firestore, Storage)
- **SharedPreferences**: Armazenamento local
- **Lottie**: Animações
- **Material 3**: Design system

## 📱 Telas

1. **Splash**: Tela de carregamento
2. **Onboarding**: Introdução ao app
3. **Login/Register**: Autenticação
4. **Home**: Dashboard principal
5. **Estudos**: Sistema de lições
6. **Jogos**: Jogos interativos por matéria
7. **Biblioteca**: PDFs organizados por matéria
8. **Perfil**: Estatísticas do usuário

## 🎨 Design System

### Cores
- **Primary**: Azul (#4A90E2)
- **Secondary**: Verde (#7ED321)
- **Tertiary**: Laranja (#FF9500)
- **Success**: Verde (#7ED321)
- **Warning**: Laranja (#FF9500)
- **Error**: Vermelho (#FF3B30)

### Tipografia
- **Fonte**: Poppins
- **Tamanhos**: 12px a 32px
- **Pesos**: Regular, Medium, SemiBold, Bold

## 🚀 Como Executar

1. **Pré-requisitos**:
   - Flutter 3.24+
   - Dart 3.0+
   - Android Studio / VS Code

2. **Instalação**:
   ```bash
   git clone https://github.com/FabioSonats/enceja-plus.git
   cd encceja-plus
   flutter pub get
   ```

3. **Executar**:
   ```bash
   # Mobile
   flutter run
   
   # Web
   flutter run -d chrome
   
   # Desktop
   flutter run -d windows
   ```

## 🧪 Testes

```bash
# Testes unitários
flutter test

# Testes de integração
flutter test integration_test/

# Análise de código
flutter analyze
```

## 📦 Dependências Principais

- flutter_bloc: Gerenciamento de estado
- go_router: Navegação
- firebase_core: Firebase
- firebase_auth: Autenticação
- cloud_firestore: Banco de dados
- shared_preferences: Armazenamento local
- lottie: Animações
- google_sign_in: Login com Google

## 🎯 Próximos Passos

1. **Implementar componentes genéricos para jogos**
2. **Criar sistema de estudos completo**
3. **Adicionar mais tipos de exercícios**
4. **Integrar Firebase**
5. **Adicionar notificações**
6. **Implementar gamificação completa**
7. **Testes automatizados**
8. **Deploy para produção**

## 📄 Licença

Este projeto está sob a licença MIT. Veja o arquivo [LICENSE](LICENSE) para mais detalhes.

## 🤝 Contribuição

Contribuições são bem-vindas! Por favor, abra uma issue ou pull request.

## 📞 Contato

- **Desenvolvedor**: Fábio Ferreira
- **Email**: [ferreirafabio51@gmail.com](mailto:ferreirafabio51@gmail.com)
- **LinkedIn**: [https://www.linkedin.com/in/ferreira-fábio-98b4304a/](https://www.linkedin.com/in/ferreira-fábio-98b4304a/)

---

**ENCCEJA+** - Sua jornada para o sucesso começa aqui! 🎓✨