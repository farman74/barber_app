import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../core/app_theme.dart';
import 'auth/login_screen.dart'; // Assure-toi que le chemin est bon

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  // Fonction de déconnexion
  Future<void> _signOut(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    
    if (context.mounted) {
      // Retour à l'écran de connexion en effaçant tout l'historique de navigation
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const LoginScreen()),
        (Route<dynamic> route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final email = user?.email ?? "Non connecté";
    final initial = email.isNotEmpty ? email[0].toUpperCase() : "?";

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("Mon Profil"),
        backgroundColor: Colors.black,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () {
              // TODO: Paramètres
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // 1. AVATAR ET NOM
            Center(
              child: Column(
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppTheme.cardLight,
                      border: Border.all(color: AppTheme.primaryPurple, width: 2),
                    ),
                    child: Center(
                      child: Text(
                        initial,
                        style: const TextStyle(fontSize: 40, color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  Text(
                    email,
                    style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 5),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white10,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Text("Membre Gratuit", style: TextStyle(color: Colors.grey, fontSize: 12)),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),

            // 2. MENU OPTIONS
            _buildMenuTile(
              icon: Icons.person_outline,
              title: "Informations personnelles",
              onTap: () {},
            ),
            _buildMenuTile(
              icon: Icons.history,
              title: "Historique des coiffures",
              onTap: () {
                // Rediriger vers l'onglet Galerie (via MainContainer idéalement, ou push)
              },
            ),
            _buildMenuTile(
              icon: Icons.star_outline,
              title: "Noter l'application",
              onTap: () {},
            ),
            
            const SizedBox(height: 20),
            
            // 3. ABONNEMENT (Placeholder pour plus tard)
            Container(
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [AppTheme.primaryPurple, Color(0xFF4A00E0)]),
                borderRadius: BorderRadius.circular(15),
              ),
              child: ListTile(
                leading: const Icon(Icons.diamond_outlined, color: Colors.white),
                title: const Text("Passer à la version PRO", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                subtitle: const Text("Débloquez tous les styles", style: TextStyle(color: Colors.white70, fontSize: 12)),
                trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 16),
                onTap: () {
                  // TODO: Page d'abonnement
                },
              ),
            ),

            const SizedBox(height: 40),

            // 4. DÉCONNEXION
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.redAccent),
              title: const Text("Se déconnecter", style: TextStyle(color: Colors.redAccent)),
              onTap: () => _signOut(context),
            ),
            
            const SizedBox(height: 20),
            const Text("Version 1.0.0", style: TextStyle(color: Colors.grey, fontSize: 10)),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuTile({required IconData icon, required String title, required VoidCallback onTap}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: AppTheme.cardLight,
        borderRadius: BorderRadius.circular(15),
      ),
      child: ListTile(
        leading: Icon(icon, color: Colors.white),
        title: Text(title, style: const TextStyle(color: Colors.white)),
        trailing: const Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 16),
        onTap: onTap,
      ),
    );
  }
}