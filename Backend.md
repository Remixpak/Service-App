# Backend
Este archivo explica como configurar el backend (en este caso firebase) para  usar los servicios de authentication y firestore

# Configuración
1. Crear el proyecto en firebase
    1. Ir a https://console.firebase.google.com
    2. Crear un Proyecto
2. Registrar App 
    1. Seleccionar plataforma (android, ios, flutter, etc) Para este caso se usó flutter
    2. Instalar Firebase CLI (si ya la tienes omite este paso)
        1. Seleccionar manera de instalación (binario independiente o npm) en este caso se explica con el segundo
        2. Abrir CMD
        3. Copiar npm install -g firebase-tools
        4. Iniciar sesión con el comando firebase login
        5. Verificar usando firebase projects: list para listar todos los proyectos
    3. Instalar el SDK de flutter (si ya lo tienes instalado omite este paso)
    4. Crear proyecto de flutter (si ya lo tienes creado omite este paso)
3. Instalar la CLI de FlutterFire
    1. Desde cualquier directorio ejecutar "dart pub global activate flutterfire_cli
    2. En la raíz del proyecto ejecutar "flutterfire configure ..." (varía según proyecto)
    3. Seleccionar las plataformas para las cual configurar
    4. Istalar la dependencia firebase_core "flutter pub add firebase_core"
    5. importar firebase_core y firebase_options (este último creado en el paso 3) en el archivo main
    6. dentro del main copiar:
        await Firebase.initializeAPP(
            WidgetsFLutterBinding.ensureInitiealized();
            options: DefaultFirebaseOptions.currentPlatform,
        );
    7. Instalar los servicios que se quieran usar





