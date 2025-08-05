# Flutter

Um aplicativo móvel moderno baseado em Flutter que utiliza as mais recentes tecnologias e ferramentas de desenvolvimento móvel para criar aplicativos multiplataforma responsivos. App sendo criado em um ambiente de desenvolvimento gerenciado por IA.

## 📋 Requisitos para Downloads do Projeto

- Flutter SDK (^3.29.2)
- Dart SDK
- Android Studio / VS Code com extensões do Flutter
- Android SDK / Xcode (para iOS development)

## 🛠️ Instalação

1. Instale as dependências:
```bash
flutter pub get
```

2. Inicie a aplicação:
```bash
flutter run
```

## 📁 Estrutura do projeto

```
flutter_app/
├── android/            # Android-specific configuration
├── ios/                # iOS-specific configuration
├── lib/
│   ├── core/           # Core utilities and services
│   │   └── utils/      # Utility classes
│   ├── presentation/   # UI screens and widgets
│   │   └── splash_screen/ # Splash screen implementation
│   ├── routes/         # Application routing
│   ├── theme/          # Theme configuration
│   ├── widgets/        # Reusable UI components
│   └── main.dart       # Application entry point
├── assets/             # Static assets (images, fonts, etc.)
├── pubspec.yaml        # Project dependencies and configuration
└── README.md           # Project documentation
```

## 🧩 Routas futuras

Para adicionar novas rotas na aplicação, atualize o arquivo `lib/routes/app_routes.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:package_name/presentation/home_screen/home_screen.dart';

class AppRoutes {
  static const String initial = '/';
  static const String home = '/home';

  static Map<String, WidgetBuilder> routes = {
    initial: (context) => const SplashScreen(),
    home: (context) => const HomeScreen(),
    // Adicione mais rotas se necessário
  }
}
```

## 🎨 Tema

Este projeto inclui um sistema de temas abrangente com temas claros e escuros:

```dart
// Acesso ao tema atual
ThemeData theme = Theme.of(context);

// use a cor do tema
Color primaryColor = theme.colorScheme.primary;
```

A configuração do tema inclui:
- Esquemas de cores para os modos claro e escuro
- Estilos de tipografia
- Temas para botões
- Temas para decoração de entrada
- Temas para cartões e diálogos

## 📱Design Responsivo 

O app foi construído com um design responsivo utilizando o Sizer package:

```dart
// Examplo de tamanho responsivo
Container(
  width: 50.w, // 50% da tela (width)
  height: 20.h, // 20% da tela (height)
  child: Text('Responsive Container'),
)
```
## 📦 Implementação

Crie o aplicativo para produção:

```bash
# For Android
flutter build apk --release

# For iOS
flutter build ios --release
```

