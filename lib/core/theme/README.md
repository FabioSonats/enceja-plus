# 🎨 Sistema de Cores e Estilos - ENCCEJA Plus

## 📋 Visão Geral

Este sistema de cores e estilos foi desenvolvido para garantir consistência visual e facilitar o desenvolvimento de interfaces no aplicativo ENCCEJA Plus.

## 🏗️ Estrutura

### 1. **AppTheme** (`app_theme.dart`)
- Cores principais do sistema
- Cores temáticas por matéria
- Cores de gamificação
- Cores de fundo e superfície
- Cores neutras
- Gradientes predefinidos
- Temas Material Design (claro/escuro)

### 2. **ColorConstants** (`color_constants.dart`)
- Acesso simplificado às cores
- Métodos utilitários para cores dinâmicas
- Funções para manipulação de cores

### 3. **StyleConstants** (`style_constants.dart`)
- Estilos predefinidos para componentes
- Constantes de espaçamento e bordas
- Estilos de texto padronizados
- Decorações de card e botão

## 🎯 Como Usar

### Cores Básicas

```dart
import 'package:encceja_plus/core/constants/color_constants.dart';

// Cores principais
Color primary = ColorConstants.primary;
Color secondary = ColorConstants.secondary;
Color success = ColorConstants.success;
Color error = ColorConstants.error;
```

### Cores por Matéria

```dart
// Cores específicas por matéria
Color mathColor = ColorConstants.math;
Color portugueseColor = ColorConstants.portuguese;
Color scienceColor = ColorConstants.science;

// Ou usando métodos dinâmicos
Color subjectColor = ColorConstants.getSubjectColor('Matemática');
Color subjectLightColor = ColorConstants.getSubjectLightColor('Português');
Color subjectDarkColor = ColorConstants.getSubjectDarkColor('Ciências');
```

### Gradientes

```dart
import 'package:encceja_plus/core/theme/app_theme.dart';

// Gradientes predefinidos
LinearGradient mathGradient = AppTheme.mathGradient;
LinearGradient primaryGradient = AppTheme.primaryGradient;

// Gradiente dinâmico por matéria
LinearGradient subjectGradient = ColorConstants.getSubjectGradient('História');
```

### Estilos Predefinidos

```dart
import 'package:encceja_plus/core/constants/style_constants.dart';

// Estilos de texto
Text('Título', style: StyleConstants.heading1)
Text('Corpo', style: StyleConstants.bodyLarge)
Text('Pequeno', style: StyleConstants.bodySmall)

// Estilos de botão
ElevatedButton(
  onPressed: () {},
  style: StyleConstants.primaryButton,
  child: Text('Botão Primário'),
)

// Estilos de card
Container(
  decoration: StyleConstants.cardDecoration,
  child: Text('Card'),
)
```

### Cards Temáticos

```dart
// Card com cor da matéria
Container(
  decoration: StyleConstants.getSubjectCardDecoration('Matemática'),
  child: Text('Card de Matemática'),
)

// Botão com cor da matéria
ElevatedButton(
  onPressed: () {},
  style: StyleConstants.getSubjectButtonStyle('Português'),
  child: Text('Estudar Português'),
)
```

## 🎨 Paleta de Cores

### Cores Principais
- **Primary**: `#4A90E2` (Azul)
- **Secondary**: `#7ED321` (Verde)
- **Accent**: `#FF9500` (Laranja)

### Cores por Matéria
- **Matemática**: `#4A90E2` (Azul)
- **Português**: `#7ED321` (Verde)
- **Ciências**: `#9C27B0` (Roxo)
- **História**: `#FF9800` (Laranja)
- **Geografia**: `#00BCD4` (Ciano)
- **Redação**: `#E91E63` (Rosa)

### Cores de Gamificação
- **XP**: `#FFCC00` (Amarelo)
- **Level**: `#AF52DE` (Roxo)
- **Achievement**: `#FF6B35` (Laranja)
- **Progress**: `#4CAF50` (Verde)
- **Streak**: `#FF5722` (Laranja escuro)

## 🔧 Funcionalidades Avançadas

### Manipulação de Cores

```dart
// Adicionar opacidade
Color semiTransparent = ColorConstants.withOpacity(ColorConstants.primary, 0.5);

// Clarear cor
Color lighter = ColorConstants.lighten(ColorConstants.primary, 0.2);

// Escurecer cor
Color darker = ColorConstants.darken(ColorConstants.primary, 0.2);
```

### Temas Dinâmicos

```dart
// Usar tema claro
ThemeData lightTheme = AppTheme.lightTheme;

// Usar tema escuro
ThemeData darkTheme = AppTheme.darkTheme;
```

## 📱 Responsividade

O sistema inclui constantes para diferentes tamanhos de tela:

```dart
// Espaçamentos
EdgeInsets.all(StyleConstants.spacingM)
EdgeInsets.symmetric(horizontal: StyleConstants.spacingL)

// Bordas
BorderRadius.circular(StyleConstants.radiusMedium)

// Elevações
BoxShadow(blurRadius: StyleConstants.elevationSmall)
```

## 🎯 Boas Práticas

1. **Use as constantes** em vez de cores hardcoded
2. **Prefira métodos dinâmicos** para cores de matéria
3. **Use estilos predefinidos** para consistência
4. **Teste em ambos os temas** (claro/escuro)
5. **Mantenha a acessibilidade** em mente

## 🚀 Exemplos Práticos

### Card de Matéria

```dart
Container(
  decoration: StyleConstants.getSubjectCardDecoration('Matemática'),
  child: Column(
    children: [
      Text('Matemática', style: StyleConstants.heading3),
      LinearProgressIndicator(
        value: 0.75,
        backgroundColor: ColorConstants.neutral200,
        valueColor: AlwaysStoppedAnimation(ColorConstants.math),
      ),
      ElevatedButton(
        onPressed: () {},
        style: StyleConstants.getSubjectButtonStyle('Matemática'),
        child: Text('Continuar'),
      ),
    ],
  ),
)
```

### AppBar Temático

```dart
AppBar(
  title: Text('Matemática'),
  backgroundColor: ColorConstants.math,
  flexibleSpace: Container(
    decoration: BoxDecoration(
      gradient: AppTheme.mathGradient,
    ),
  ),
)
```

Este sistema garante consistência visual e facilita a manutenção do design em todo o aplicativo! 🎨✨
