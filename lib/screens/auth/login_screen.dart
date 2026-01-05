import 'package:barber_app/services/auth_service.dart';
import 'package:flutter/material.dart';
import '../../core/app_theme.dart';
import '../../widgets/custom_text_field.dart';
import '../main_container.dart'; // Pour aller vers l'accueil après connexion
import 'signup_screen.dart';   // Pour aller vers l'inscription

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: SingleChildScrollView( // Pour éviter le débordement si le clavier s'ouvre
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 50),
                
                // 1. HEADER (Logo ou Titre)
                Center(
                  child: Container(
                    height: 80, width: 80,
                    decoration: BoxDecoration(
                      color: AppTheme.primaryPurple.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.content_cut, size: 40, color: AppTheme.primaryPurple),
                  ),
                ),
                const SizedBox(height: 30),
                const Text(
                  "Bon retour 👋",
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                const Text(
                  "Connectez-vous pour retrouver vos styles.",
                  style: TextStyle(color: Colors.grey, fontSize: 16),
                ),

                const SizedBox(height: 40),

                // 2. FORMULAIRE
                CustomTextField(
                  hintText: "Email",
                  icon: Icons.email_outlined,
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 20),
                CustomTextField(
                  hintText: "Mot de passe",
                  icon: Icons.lock_outline,
                  isPassword: true,
                  controller: _passwordController,
                ),

                // Mot de passe oublié
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {},
                    child: const Text("Mot de passe oublié ?", style: TextStyle(color: AppTheme.primaryPurple)),
                  ),
                ),

                const SizedBox(height: 30),

                // 3. BOUTON DE CONNEXION
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  // ...
                child: ElevatedButton(
                  onPressed: _isLoading ? null : () async {
                    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Email et mot de passe requis")));
                      return;
                    }

                    setState(() => _isLoading = true);

                    try {
                      await _authService.signIn(
                        email: _emailController.text.trim(),
                        password: _passwordController.text.trim(),
                      );

                      // Succès
                      if (mounted) {
                        Navigator.pushReplacement(
                          context, 
                          MaterialPageRoute(builder: (context) => const MainContainer())
                        );
                      }
                    } catch (e) {
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text("Erreur : Vérifiez vos identifiants"),
                          backgroundColor: Colors.red,
                        ));
                      }
                    } finally {
                      if (mounted) setState(() => _isLoading = false);
                    }
                  },
                  child: _isLoading 
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text("Se connecter", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                ),
                  // ...
                ),

                const SizedBox(height: 30),

                // 4. DIVISEUR "OU"
                Row(
                  children: const [
                    Expanded(child: Divider(color: Colors.white24)),
                    Padding(padding: EdgeInsets.symmetric(horizontal: 10), child: Text("OU", style: TextStyle(color: Colors.grey))),
                    Expanded(child: Divider(color: Colors.white24)),
                  ],
                ),

                const SizedBox(height: 30),

                // 5. GOOGLE SIGN IN
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: OutlinedButton.icon(
                    onPressed: () {
                      print("Google Sign In");
                    },
                    icon: const Icon(Icons.g_mobiledata, size: 30), // Icône Google simple
                    label: const Text("Continuer avec Google"),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white,
                      side: const BorderSide(color: Colors.white24),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    ),
                  ),
                ),

                const SizedBox(height: 50),

                // 6. LIEN VERS INSCRIPTION
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Pas encore de compte ? ", style: TextStyle(color: Colors.grey)),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const SignupScreen()),
                        );
                      },
                      child: const Text(
                        "S'inscrire",
                        style: TextStyle(color: AppTheme.primaryPurple, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}