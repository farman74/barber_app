// Fichier : lib/main.dart

import 'package:barber_app/screens/auth/login_screen.dart';
import 'package:barber_app/screens/main_container.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'core/app_theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart'; // Ce fichier a été créé à l'étape 1

void main() async {
  // 1. On s'assure que les widgets sont prêts
  WidgetsFlutterBinding.ensureInitialized();
  
  // 2. On initialise Firebase avec la config générée
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // 3. On lance l'app
  runApp(const HairAIApp());
}

class HairAIApp extends StatelessWidget {
  const HairAIApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Titre de l'application (visible dans le multitâche)
      title: 'AI Barber',
      
      // Enlève le bandeau "DEBUG" en haut à droite
      debugShowCheckedModeBanner: false,
      
      // Application de notre thème sombre personnalisé
      theme: AppTheme.darkTheme,
      themeMode: ThemeMode.dark, // Force le mode sombre quoi qu'il arrive
      
      // La page de démarrage : Le conteneur principal (avec la barre de nav)
    
      // LOGIQUE DE DÉMARRAGE :
      // On écoute l'état de l'authentification
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          // Si on a des données, l'utilisateur est connecté -> Accueil
          if (snapshot.hasData) {
            return const MainContainer();
          }
          // Sinon -> Login
          return const LoginScreen();
        },
      ),
    );
  }
}