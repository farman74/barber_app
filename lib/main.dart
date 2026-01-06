import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Import ajouté
import 'firebase_options.dart';
import 'core/app_theme.dart';
import 'screens/auth/login_screen.dart';
import 'screens/main_container.dart';
import 'screens/onboarding_screen.dart'; // Import ajouté

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AI Barber',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme, // Ton thème sombre
      home: const AuthWrapper(), // On lance le "Wrapper" intelligent
    );
  }
}

// Ce Widget décide quelle page afficher au démarrage
class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  bool? _seenOnboarding;

  @override
  void initState() {
    super.initState();
    _checkOnboarding();
  }

  // Vérifie la mémoire du téléphone
  Future<void> _checkOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _seenOnboarding = prefs.getBool('seenOnboarding') ?? false;
    });
  }

  @override
  Widget build(BuildContext context) {
    // 1. Si on ne sait pas encore (chargement de la mémoire), on affiche un écran noir
    if (_seenOnboarding == null) {
      return const Scaffold(backgroundColor: Colors.black, body: Center(child: CircularProgressIndicator()));
    }

    // 2. On écoute Firebase Auth
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // Si l'utilisateur est connecté -> ACCUEIL
        if (snapshot.hasData) {
          return const MainContainer();
        }
        
        // Si pas connecté et JAMAIS vu l'intro -> ONBOARDING
        if (!_seenOnboarding!) {
          return const OnboardingScreen();
        }

        // Sinon -> LOGIN
        return const LoginScreen();
      },
    );
  }
}