import 'package:flutter/material.dart';
import '../core/app_theme.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // SafeArea : Empêche le contenu de toucher la barre de statut (batterie/heure)
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              
              // ---------------------------------------------------------
              // 1. HEADER (Photo + Nom)
              // ---------------------------------------------------------
              Center(
                child: Column(
                  children: [
                    // Stack permet de superposer des éléments (Photo + Badge étoile)
                    Stack(
                      children: [
                        // La photo de profil ronde
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: AppTheme.primaryPurple, width: 2), // Bordure violette
                          ),
                          child: const CircleAvatar(
                            radius: 50, // Taille de l'image
                            backgroundImage: NetworkImage("https://i.pravatar.cc/300?img=11"), // Image exemple
                          ),
                        ),
                        // Le petit badge en bas à droite
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: const BoxDecoration(
                              color: AppTheme.primaryPurple,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.star, color: Colors.white, size: 20),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 15),
                    // Nom de l'utilisateur
                    const Text(
                      "Jean Dupont", 
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)
                    ),
                    // Email
                    const Text(
                      "jean.dupont@email.com", 
                      style: TextStyle(color: AppTheme.textGrey)
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // ---------------------------------------------------------
              // 2. STATISTIQUES (Simulations / Crédits)
              // ---------------------------------------------------------
              Row(
                children: [
                  // Expanded force le widget à prendre 50% de la largeur disponible
                  Expanded(
                    child: _buildStatCard("12", "SIMULATIONS")
                  ),
                  const SizedBox(width: 15), // Espace entre les deux cartes
                  Expanded(
                    child: _buildStatCard("5", "CRÉDITS")
                  ),
                ],
              ),

              const SizedBox(height: 30),

              // ---------------------------------------------------------
              // 3. MENU (Liste des options)
              // ---------------------------------------------------------
              // On appelle notre fonction helper pour chaque ligne du menu
              _buildMenuItem(Icons.credit_card, "Abonnement", trailing: "Plan Gratuit"),
              _buildMenuItem(Icons.notifications_none, "Notifications", trailing: "Activées"),
              _buildMenuItem(Icons.shield_outlined, "Confidentialité"),
              _buildMenuItem(Icons.settings_outlined, "Paramètres"),

              const SizedBox(height: 30),

              // ---------------------------------------------------------
              // 4. BANNIÈRE PRO (Appel à l'action)
              // ---------------------------------------------------------
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  // Dégradé violet/bleu comme sur la maquette
                  gradient: const LinearGradient(
                    colors: [Color(0xFF4A00E0), Color(0xFF8E2DE2)], 
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF4A00E0).withOpacity(0.4),
                      blurRadius: 15,
                      offset: const Offset(0, 5),
                    )
                  ]
                ),
                child: Column(
                  children: [
                    const Text(
                      "Passez à la version Pro", 
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white)
                    ),
                    const SizedBox(height: 5),
                    const Text(
                      "Accès illimité, pas de watermark, et nouveaux styles chaque semaine.", 
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white70, fontSize: 12),
                    ),
                    const SizedBox(height: 15),
                    // Bouton Blanc à l'intérieur du bloc violet
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white, // Fond blanc
                        foregroundColor: AppTheme.primaryPurple, // Texte violet
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12)
                      ),
                      onPressed: () {
                        print("Click: Upgrade Pro");
                      },
                      child: const Text("Essayer gratuitement"),
                    )
                  ],
                ),
              ),
              
              const SizedBox(height: 30),

              // ---------------------------------------------------------
              // 5. BOUTON DÉCONNEXION
              // ---------------------------------------------------------
              TextButton.icon(
                onPressed: () {
                  print("Click: Déconnexion");
                },
                icon: const Icon(Icons.logout, color: Colors.redAccent),
                label: const Text("Déconnexion", style: TextStyle(color: Colors.redAccent)),
              ),
              
              // Espace pour le scroll en bas
              const SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }

  // --- WIDGETS HELPER (Pour éviter de répéter le code) ---

  // 1. Carte de Statistique (Carré gris avec Chiffre + Titre)
  Widget _buildStatCard(String count, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        color: AppTheme.cardLight, // Gris sombre
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white12), // Fine bordure
      ),
      child: Column(
        children: [
          Text(
            count, 
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)
          ),
          const SizedBox(height: 5),
          Text(
            label, 
            style: const TextStyle(
              color: AppTheme.textGrey, 
              fontSize: 10, 
              letterSpacing: 1.5,
              fontWeight: FontWeight.w600
            )
          ),
        ],
      ),
    );
  }

  // 2. Ligne de Menu (Icone + Texte + Flèche)
  Widget _buildMenuItem(IconData icon, String title, {String? trailing}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10), // Espace sous chaque élément
      decoration: BoxDecoration(
        color: AppTheme.cardDark,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.white10), // Bordure très subtile
      ),
      child: ListTile(
        leading: Icon(icon, color: AppTheme.primaryPurple), // Icône à gauche
        title: Text(title, style: const TextStyle(fontSize: 14, color: Colors.white)),
        // Trailing est l'élément tout à droite
        trailing: Row(
          mainAxisSize: MainAxisSize.min, // Prend le moins de place possible
          children: [
            if (trailing != null) ...[ // Si on a un texte "trailing" (ex: "Plan Gratuit"), on l'affiche
              Text(trailing, style: const TextStyle(color: AppTheme.textGrey, fontSize: 12)),
              const SizedBox(width: 10),
            ],
            const Icon(Icons.chevron_right, color: AppTheme.textGrey, size: 20), // Flèche droite
          ],
        ),
        onTap: () {
          print("Menu: $title");
        },
      ),
    );
  }
}