import 'package:flutter/material.dart';
import '../core/app_theme.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Variable pour savoir quel filtre est sélectionné (0 = Tout, 1 = Dégradés, etc.)
  int _selectedFilterIndex = 0;

  // Liste des filtres pour la barre de navigation horizontale
  final List<String> _filters = ["Tout", "Dégradés", "Afro", "Tresses", "Locks", "Court"];

  @override
  Widget build(BuildContext context) {
    // Scaffold est la structure de base d'une page
    return Scaffold(
      // SafeArea permet d'éviter que le contenu soit caché par l'encoche (notch) du téléphone
      body: SafeArea(
        child: SingleChildScrollView( // Permet de scroller si l'écran est petit
          padding: const EdgeInsets.all(20), // Marge de 20px tout autour
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              
              // -----------------------------------------------------------
              // 1. LE HEADER (Bienvenue + Crédits)
              // -----------------------------------------------------------
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween, // Espace max entre les deux éléments
                children: [
                  // Partie Gauche : Textes
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "BIENVENUE", 
                        style: TextStyle(
                          color: AppTheme.textGrey, 
                          fontSize: 12, 
                          letterSpacing: 1.5, // Espacement des lettres pour le style "Luxe"
                          fontWeight: FontWeight.w600
                        )
                      ),
                      const SizedBox(height: 5),
                      const Text(
                        "Jean Dupont", 
                        style: TextStyle(
                          color: Colors.white, 
                          fontSize: 24, 
                          fontWeight: FontWeight.bold
                        )
                      ),
                    ],
                  ),

                  // Partie Droite : Badge Crédits
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppTheme.cardLight, // Fond gris léger
                      borderRadius: BorderRadius.circular(20), // Bords très arrondis
                      border: Border.all(color: Colors.white10), // Fine bordure subtile
                    ),
                    child: Row(
                      children: [
                        // Petit point violet qui brille
                        const Icon(Icons.circle, size: 10, color: AppTheme.primaryPurple),
                        const SizedBox(width: 8),
                        const Text(
                          "5 Crédits", 
                          style: TextStyle(
                            color: Colors.white, 
                            fontWeight: FontWeight.bold,
                            fontSize: 12
                          )
                        ),
                      ],
                    ),
                  )
                ],
              ),
              
              const SizedBox(height: 30), // Espace vertical

              // -----------------------------------------------------------
              // 2. BANNIÈRE HERO (Mise en avant d'un style)
              // -----------------------------------------------------------
              Container(
                height: 250,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  // Image de fond (Placeholder)
                  image: const DecorationImage(
                    image: NetworkImage("https://images.unsplash.com/photo-1599351431202-1e0f0137899a?q=80&w=1000&auto=format&fit=crop"), 
                    fit: BoxFit.cover, // L'image couvre tout le conteneur
                  ),
                ),
                child: Container(
                  // Dégradé noir par-dessus l'image pour que le texte soit lisible
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent, 
                        Colors.black.withOpacity(0.9) // Noir presque opaque en bas
                      ],
                    ),
                  ),
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end, // Aligne tout en bas
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Badge "Coup de Cœur"
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryPurple, 
                          borderRadius: BorderRadius.circular(8)
                        ),
                        child: const Text(
                          "COUP DE CŒUR", 
                          style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white)
                        ),
                      ),
                      const SizedBox(height: 10),
                      // Titre
                      const Text(
                        "Le Mid Fade : L'indémodable\nde 2025", 
                        style: TextStyle(
                          color: Colors.white, 
                          fontSize: 22, 
                          fontWeight: FontWeight.bold,
                          height: 1.2 // Espacement des lignes
                        )
                      ),
                      const SizedBox(height: 10),
                      // Bouton CTA (Call To Action)
                      InkWell(
                        onTap: () {
                          print("Essayer le Mid Fade");
                        },
                        child: Row(
                          children: const [
                            Text(
                              "Essayer maintenant", 
                              style: TextStyle(
                                color: AppTheme.primaryPurple, 
                                fontWeight: FontWeight.bold
                              )
                            ),
                            SizedBox(width: 5),
                            Icon(Icons.arrow_forward, color: AppTheme.primaryPurple, size: 18)
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 30),

              // -----------------------------------------------------------
              // 3. LES FILTRES (Liste horizontale)
              // -----------------------------------------------------------
              const Text(
                "EXPLORER LES COLLECTIONS", 
                style: TextStyle(
                  color: AppTheme.textGrey, 
                  fontSize: 12, 
                  fontWeight: FontWeight.bold
                )
              ),
              const SizedBox(height: 15),
              
              // Scroll horizontal pour les filtres
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: List.generate(_filters.length, (index) {
                    return _buildFilterChip(
                      label: _filters[index], 
                      isSelected: _selectedFilterIndex == index, // Vérifie si c'est le filtre actif
                      index: index
                    );
                  }),
                ),
              ),

              const SizedBox(height: 30),

              // -----------------------------------------------------------
              // 4. LES TENDANCES (Grid)
              // -----------------------------------------------------------
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: const [
                      Icon(Icons.bolt, color: Colors.yellow, size: 24), // Icône éclair
                      SizedBox(width: 8),
                      Text(
                        "Tendances", 
                        style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)
                      ),
                    ],
                  ),
                  TextButton(
                    onPressed: () {}, 
                    child: const Text(
                      "VOIR TOUT", 
                      style: TextStyle(color: AppTheme.primaryPurple, fontSize: 12, fontWeight: FontWeight.bold)
                    )
                  ),
                ],
              ),
              const SizedBox(height: 15),
              
              // Grille d'images (Exemple simple)
              GridView.builder(
                shrinkWrap: true, // Important : permet au GridView de tenir dans le SingleChildScrollView
                physics: const NeverScrollableScrollPhysics(), // Désactive le scroll propre à la grille
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // 2 colonnes
                  childAspectRatio: 0.8, // Format portrait (hauteur > largeur)
                  crossAxisSpacing: 15, // Espace horizontal
                  mainAxisSpacing: 15, // Espace vertical
                ),
                itemCount: 4, // 4 éléments pour l'exemple
                itemBuilder: (context, index) {
                  return _buildTrendCard(index);
                },
              ),

              // --- AJOUTER CECI ICI ---
              _buildProBanner(), 
              // -----------------------
              
              // Espace en bas pour ne pas être coupé par la barre de navigation
              const SizedBox(height: 80), 
            ],
          ),
        ),
      ),
    );
  }

  // --- WIDGETS HELPER (Pour garder le code principal propre) ---

  // Widget pour un bouton filtre (Chip)
  Widget _buildFilterChip({required String label, required bool isSelected, required int index}) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedFilterIndex = index; // Change la sélection et rafraîchit l'écran
        });
      },
      child: Container(
        margin: const EdgeInsets.only(right: 10), // Marge à droite de chaque chip
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          // Si sélectionné : fond blanc, Sinon : fond gris foncé
          color: isSelected ? Colors.white : AppTheme.cardLight,
          borderRadius: BorderRadius.circular(30),
          // Si pas sélectionné : petite bordure
          border: isSelected ? null : Border.all(color: Colors.white12),
        ),
        child: Text(
          label,
          style: TextStyle(
            // Si sélectionné : texte noir, Sinon : texte blanc
            color: isSelected ? Colors.black : Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  // Widget pour une carte de tendance (Image simple)
  Widget _buildTrendCard(int index) {
    // Liste d'URLs d'exemple (Tu pourras remplacer par ton backend plus tard)
    final List<String> images = [
      "https://images.unsplash.com/photo-1605497788044-5a32c7078486?q=80&w=500",
      "https://images.unsplash.com/photo-1621605815971-fbc98d665033?q=80&w=500",
      "https://images.unsplash.com/photo-1503951914875-befbb71359e0?q=80&w=500",
      "https://images.unsplash.com/photo-1517832606299-7ae9b720a186?q=80&w=500",
    ];

    return Container(
      decoration: BoxDecoration(
        color: AppTheme.cardLight,
        borderRadius: BorderRadius.circular(20),
        image: DecorationImage(
          image: NetworkImage(images[index % images.length]), // Utilise modulo pour éviter les erreurs d'index
          fit: BoxFit.cover,
        ),
      ),
      // Ajout d'un petit dégradé en bas de la carte pour le nom (optionnel)
      child: Align(
        alignment: Alignment.bottomLeft,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.vertical(bottom: Radius.circular(20)),
            gradient: LinearGradient(
              colors: [Colors.transparent, Colors.black.withOpacity(0.8)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter
            )
          ),
          child: Text(
            "Style #${index + 1}", 
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)
          ),
        ),
      ),
    );
  }


  // -------------------------------------------------------
  // 5. WIDGET : BANNIÈRE PRO (Le bloc noir en bas)
  // -------------------------------------------------------
  Widget _buildProBanner() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 30, bottom: 20), // Espacement haut/bas
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
      decoration: BoxDecoration(
        color: AppTheme.cardDark, // Fond gris très foncé (#121212)
        borderRadius: BorderRadius.circular(30), // Coins très arrondis
        border: Border.all(color: Colors.white.withOpacity(0.05)), // Bordure très subtile
      ),
      child: Column(
        children: [
          // L'icône étoile violette dans un cercle sombre
          Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: const Color(0xFF1A1A2E), // Fond du cercle (violet très sombre)
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.auto_awesome, color: AppTheme.primaryPurple, size: 30),
          ),
          
          const SizedBox(height: 20),
          
          // Titre
          const Text(
            "Passez au niveau supérieur",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          
          const SizedBox(height: 10),
          
          // Sous-titre
          const Text(
            "Styles illimités, HD et sans watermark.",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppTheme.textGrey,
              fontSize: 14,
            ),
          ),

          const SizedBox(height: 25),

          // Le Bouton Blanc
          SizedBox(
            width: double.infinity, // Prend toute la largeur
            height: 55,
            child: ElevatedButton(
              onPressed: () {
                print("Ouvrir la page d'abonnement");
                // TODO: Navigation vers la page de paiement
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white, // Fond BLANC
                foregroundColor: Colors.black, // Texte NOIR
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: const Text(
                "Découvrir l'offre Pro",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

}