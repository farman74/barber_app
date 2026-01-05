import 'package:barber_app/services/auth_service.dart';
import 'package:flutter/material.dart';
import '../../core/app_theme.dart';
import '../../widgets/custom_text_field.dart';
import '../main_container.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isLoading = false; // <--- AJOUTER CECI
  final AuthService _authService = AuthService(); // <--- AJOUTER CECI

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context), // Retour au login
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Créer un compte 🚀",
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                const Text(
                  "Rejoignez la communauté et trouvez votre style.",
                  style: TextStyle(color: Colors.grey, fontSize: 16),
                ),

                const SizedBox(height: 40),

                // Nom
                CustomTextField(
                  hintText: "Nom complet",
                  icon: Icons.person_outline,
                  controller: _nameController,
                ),
                const SizedBox(height: 20),
                
                // Email
                CustomTextField(
                  hintText: "Email",
                  icon: Icons.email_outlined,
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 20),
                
                // Mot de passe
                CustomTextField(
                  hintText: "Mot de passe",
                  icon: Icons.lock_outline,
                  isPassword: true,
                  controller: _passwordController,
                ),

                const SizedBox(height: 40),

                // Bouton Inscription
                // ...
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : () async { // Désactive si chargement
                      // 1. Vérification simple
                      if (_nameController.text.isEmpty || _emailController.text.isEmpty || _passwordController.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Veuillez remplir tous les champs")));
                        return;
                      }

                      setState(() => _isLoading = true); // Affiche le chargement

                      try {
                        // 2. Appel à Firebase via notre Service
                        await _authService.signUp(
                          email: _emailController.text.trim(),
                          password: _passwordController.text.trim(),
                          name: _nameController.text.trim(),
                        );

                        // 3. Succès : On va à l'accueil
                        if (mounted) {
                          Navigator.pushAndRemoveUntil(
                            context, 
                            MaterialPageRoute(builder: (context) => const MainContainer()),
                            (route) => false
                          );
                        }
                      } catch (e) {
                        // 4. Erreur : On affiche le message
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(e.toString()),
                            backgroundColor: Colors.red,
                          ));
                        }
                      } finally {
                        if (mounted) setState(() => _isLoading = false); // Stop chargement
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      // ... style inchangé ...
                    ),
                    // Affiche un rond qui tourne si ça charge, sinon le texte
                    child: _isLoading 
                        ? const CircularProgressIndicator(color: Colors.white) 
                        : const Text("S'inscrire gratuitement", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                  ),
                ),
// ...
                
                const SizedBox(height: 20),
                
                Center(
                  child: Text(
                    "En vous inscrivant, vous acceptez nos CGU et notre politique de confidentialité.",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey[700], fontSize: 12),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}