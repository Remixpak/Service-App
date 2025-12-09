# INSTALL
Este documento explica cómo instalar y ejecutar el proyecto de manera local

# Requisitos previos 

- Flutter 3.35.1 o superior
- Dart 
- Visual Studio Code
- Node.js

# Instalación 

1. Colonar el repositorio
    git clone https://github.com/Remixpak/Service-App.git

2. Instalar dependencias
    flutter pub get
3. Configurar archivo .env:
    Crear en la raíz del proyecto un nuevo archivo y llamarlo .env
    Copiar detro lo siguiente: 
    FOO=foo
    BAR=bar
    FOOBAR=$FOO$BAR
    ESCAPED_DOLLAR_SIGN='$1000'
4. Configurar Firebase
    Colocar el archivo google-services.json en Service-App/android/app
    Colocar el archivo googleService-info.plist en Service-App/ios/Runner
5. Correr la app
    flutter pub run

