# ENCCEJA+ ðŸ“š

Um aplicativo Flutter multiplataforma (Web + Mobile) para ajudar pessoas a estudarem para o ENCCEJA com recursos gamificados, acesso a materiais de estudo, cronograma de inscriÃ§Ãµes e simulados.

## ðŸš€ CaracterÃ­sticas

- **GamificaÃ§Ã£o**: Sistema de XP, nÃ­veis e conquistas
- **Estudos Interativos**: LiÃ§Ãµes no estilo Duolingo
- **Simulados**: Testes baseados em provas reais do ENCCEJA
- **Cronograma**: Datas importantes e lembretes
- **Multiplataforma**: Web e Mobile
- **Tema Adaptativo**: Modo claro e escuro

## ðŸ—ï¸ Arquitetura

- **Frontend**: Flutter 3.24+
- **Arquitetura**: MVVM + SOLID + Clean Code
- **Gerenciamento de Estado**: Flutter BLoC
- **NavegaÃ§Ã£o**: Go Router
- **Tema**: Material 3
- **Design System**: Atomic Design

## ðŸ“ Estrutura do Projeto

`
lib/
â”œâ”€â”€ core/
â”‚   â”œâ”€â”€ constants/          # Constantes da aplicaÃ§Ã£o
â”‚   â”œâ”€â”€ errors/            # Tratamento de erros
â”‚   â”œâ”€â”€ routes/            # ConfiguraÃ§Ã£o de rotas
â”‚   â”œâ”€â”€ theme/             # Temas e cores
â”‚   â””â”€â”€ utils/             # UtilitÃ¡rios
â”œâ”€â”€ data/
â”‚   â”œâ”€â”€ datasources/       # Fontes de dados
â”‚   â”œâ”€â”€ models/           # Modelos de dados
â”‚   â””â”€â”€ repositories/     # RepositÃ³rios
â”œâ”€â”€ domain/
â”‚   â”œâ”€â”€ entities/         # Entidades de negÃ³cio
â”‚   â””â”€â”€ usecases/         # Casos de uso
â””â”€â”€ presentation/
    â”œâ”€â”€ viewmodels/       # BLoCs e ViewModels
    â”œâ”€â”€ views/           # Telas da aplicaÃ§Ã£o
    â”œâ”€â”€ widgets/         # Componentes reutilizÃ¡veis
    â””â”€â”€ animations/      # AnimaÃ§Ãµes customizadas
`

## ðŸŽ® Funcionalidades

### âœ… Implementadas
- [x] Estrutura de projeto MVVM + BLoC
- [x] Sistema de autenticaÃ§Ã£o (Email, Google, AnÃ´nimo)
- [x] Onboarding gamificado
- [x] Dashboard principal
- [x] NavegaÃ§Ã£o entre telas
- [x] Tema Material 3 (claro/escuro)
- [x] Perfil do usuÃ¡rio

### ðŸš§ Em Desenvolvimento
- [ ] Sistema de estudos gamificado
- [ ] Simulados e quizzes
- [ ] Cronograma do ENCCEJA
- [ ] Sistema de conquistas
- [ ] NotificaÃ§Ãµes push
- [ ] IntegraÃ§Ã£o com Firebase

## ðŸ› ï¸ Tecnologias

- **Flutter**: Framework multiplataforma
- **BLoC**: Gerenciamento de estado
- **Go Router**: NavegaÃ§Ã£o
- **Firebase**: Backend (Auth, Firestore, Storage)
- **Hive**: Armazenamento local
- **Lottie**: AnimaÃ§Ãµes
- **Material 3**: Design system

## ðŸ“± Telas

1. **Splash**: Tela de carregamento
2. **Onboarding**: IntroduÃ§Ã£o ao app
3. **Login/Register**: AutenticaÃ§Ã£o
4. **Home**: Dashboard principal
5. **Estudos**: Sistema de liÃ§Ãµes
6. **Simulados**: Testes e quizzes
7. **Agenda**: Cronograma do ENCCEJA
8. **Perfil**: EstatÃ­sticas do usuÃ¡rio

## ðŸŽ¨ Design System

### Cores
- **Primary**: Azul (#2196F3)
- **Secondary**: Verde (#4CAF50)
- **Tertiary**: Amarelo (#FFC107)
- **Success**: Verde (#4CAF50)
- **Warning**: Laranja (#FF9800)
- **Error**: Vermelho (#F44336)

### Tipografia
- **Fonte**: Poppins
- **Tamanhos**: 12px a 32px
- **Pesos**: Regular, Medium, SemiBold, Bold

## ðŸš€ Como Executar

1. **PrÃ©-requisitos**:
   - Flutter 3.24+
   - Dart 3.0+
   - Android Studio / VS Code

2. **InstalaÃ§Ã£o**:
   `ash
   git clone https://github.com/FabioSonats/enceja-plus.git
   cd encceja-plus
   flutter pub get
   `

3. **Executar**:
   `ash
   # Mobile
   flutter run
   
   # Web
   flutter run -d chrome
   
   # Desktop
   flutter run -d windows
   `

## ðŸ§ª Testes

`ash
# Testes unitÃ¡rios
flutter test

# Testes de integraÃ§Ã£o
flutter test integration_test/

# AnÃ¡lise de cÃ³digo
flutter analyze
`

## ðŸ“¦ DependÃªncias Principais

- lutter_bloc: Gerenciamento de estado
- go_router: NavegaÃ§Ã£o
- irebase_core: Firebase
- irebase_auth: AutenticaÃ§Ã£o
- cloud_firestore: Banco de dados
- hive: Armazenamento local
- lottie: AnimaÃ§Ãµes
- google_sign_in: Login com Google

## ðŸŽ¯ PrÃ³ximos Passos

1. **Implementar sistema de estudos**
2. **Criar simulados interativos**
3. **Integrar Firebase**
4. **Adicionar notificaÃ§Ãµes**
5. **Implementar gamificaÃ§Ã£o completa**
6. **Testes automatizados**
7. **Deploy para produÃ§Ã£o**

## ðŸ“„ LicenÃ§a

Este projeto estÃ¡ sob a licenÃ§a MIT. Veja o arquivo [LICENSE](LICENSE) para mais detalhes.

## ðŸ¤ ContribuiÃ§Ã£o

ContribuiÃ§Ãµes sÃ£o bem-vindas! Por favor, abra uma issue ou pull request.

## ðŸ“ž Contato

- **Desenvolvedor**: FÃ¡bio Ferreira
- **Email**: [ferreirafabio51@gmail.com](mailto:ferreirafabio51@gmail.com)
- **LinkedIn**: [https://www.linkedin.com/in/ferreira-fÃ¡bio-98b4304a/](https://www.linkedin.com/in/ferreira-fÃ¡bio-98b4304a/)

---

**ENCCEJA+** - Sua jornada para o sucesso comeÃ§a aqui! ðŸŽ“âœ¨
