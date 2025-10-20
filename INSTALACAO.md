# 📱 ENCCEJA+ - Instruções de Instalação

## 🚀 Instalação no Celular (Android)

### 📦 APK para Teste
O arquivo APK está localizado em:
```
build/app/outputs/flutter-apk/app-release.apk
```

### 📋 Passos para Instalação:

1. **Habilitar Fontes Desconhecidas**
   - Vá em `Configurações` > `Segurança` > `Fontes Desconhecidas`
   - Ou `Configurações` > `Aplicativos` > `Acesso Especial` > `Instalar Apps Desconhecidos`

2. **Transferir o APK**
   - Copie o arquivo `app-release.apk` para seu celular
   - Pode usar USB, email, Google Drive, etc.

3. **Instalar**
   - Abra o arquivo APK no celular
   - Toque em "Instalar"
   - Aguarde a instalação

4. **Abrir o App**
   - Procure por "ENCCEJA+" na lista de apps
   - Toque para abrir

## 🎮 Funcionalidades Disponíveis

### ✅ **Implementadas:**
- **Splash Screen** - Animação de entrada
- **Onboarding** - 4 telas explicativas
- **Login/Cadastro** - Autenticação moderna
- **Dashboard** - Tela principal com progresso
- **Navegação** - Bottom bar funcional
- **Gamificação** - Sistema de XP e níveis
- **Tema** - Modo claro/escuro

### 🔄 **Em Desenvolvimento:**
- Sistema de estudos gamificado
- Simulados com temporizador
- Agenda do ENCCEJA
- Perfil com conquistas
- Integração Firebase

## 🛠️ Desenvolvimento

### 📋 Pré-requisitos:
- Flutter 3.24+
- Dart 3.5+
- Android SDK 35+

### 🚀 Comandos Úteis:
```bash
# Instalar dependências
flutter pub get

# Executar no navegador
flutter run -d chrome

# Executar no celular
flutter run -d android

# Gerar APK
flutter build apk --release

# Gerar APK debug
flutter build apk --debug
```

## 📱 Teste no Celular

### 🔧 Configuração do Dispositivo:
1. **Habilitar Depuração USB**
   - `Configurações` > `Sobre o Telefone` > `Número da Versão` (toque 7 vezes)
   - `Configurações` > `Opções do Desenvolvedor` > `Depuração USB`

2. **Conectar via USB**
   - Conecte o celular ao computador
   - Autorize a depuração USB

3. **Executar Diretamente**
   ```bash
   flutter run -d android
   ```

## 🎯 Próximas Funcionalidades

### 📚 Sistema de Estudos
- Lições interativas estilo Duolingo
- Progresso por matéria
- Sistema de vidas e recompensas

### 🧠 Simulados
- Testes baseados em provas anteriores
- Temporizador configurável
- Ranking entre usuários

### 📅 Agenda
- Datas importantes do ENCCEJA
- Notificações automáticas
- Cronograma de estudos

### 🏆 Perfil
- Estatísticas detalhadas
- Sistema de conquistas
- Histórico de progresso

## 🐛 Problemas Conhecidos

- **Fontes Poppins**: Comentadas no pubspec.yaml (não afetam funcionamento)
- **Firebase**: Não configurado ainda (funcionalidades offline)
- **Autenticação**: Simulada (sem backend real)

## 📞 Suporte

Para dúvidas ou problemas:
- Verifique se o Android está atualizado
- Teste em modo debug primeiro
- Verifique os logs do Flutter

---

**ENCCEJA+** - Sua jornada para o sucesso começa aqui! 🎓✨
