import 'package:flutter/material.dart';
import '../core/app_theme.dart';

class StylesScreen extends StatefulWidget {
  const StylesScreen({super.key});

  @override
  State<StylesScreen> createState() => _StylesScreenState();
}

class _StylesScreenState extends State<StylesScreen> {
  // Index du filtre sélectionné (0 = Tout)
  int _selectedFilterIndex = 0;

  // Liste des catégories
  final List<String> _filters = ["Tout", "Dégradés", "Afro", "Buzz Cut", "Tresses", "Locks"];

  // ---------------------------------------------------------------------------
  // DONNÉES SIMULÉES (MOCK DATA)
  // C'est ici que tu mettras les données venant de ta base de données plus tard
  // ---------------------------------------------------------------------------
  final List<Map<String, dynamic>> _stylesData = [
    {
      "name": "Mid Fade",
      "category": "DÉGRADÉS",
      "tags": "#court #propre",
      "image": "https://images.unsplash.com/photo-1621605815971-fbc98d665033?q=80&w=500"
    },
    {
      "name": "Short Afro",
      "category": "AFRO",
      "tags": "#naturel #volume",
      "image": "https://images.unsplash.com/photo-1621784564114-6deb2924d547?q=80&w=500"
    },
    {
      "name": "Cornrows Classic",
      "category": "TRESSES",
      "tags": "#tresses #protecteur",
      "image": "https://images.unsplash.com/photo-1517832606299-7ae9b720a186?q=80&w=500"
    },
    {
      "name": "Short Locks",
      "category": "LOCKS",
      "tags": "#locks #naturel",
      "image": "https://images.unsplash.com/photo-1521146764736-56c929d59c83?q=80&w=500"
    },
    {
      "name": "Burst Fade",
      "category": "DÉGRADÉS",
      "tags": "#moderne #edgy",
      "image": "https://images.unsplash.com/photo-1605497788044-5a32c7078486?q=80&w=500"
    },
    {
      "name": "Buzz Cut",
      "category": "BUZZ CUT",
      "tags": "#militaire #simple",
      "image": "https://images.unsplash.com/photo-1493246507139-91e8fad9978e?q=80&w=500"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, // Aligne tout à gauche
          children: [
            
            // -------------------------------------------------------
            // 1. TITRE DE LA PAGE
            // -------------------------------------------------------
            const Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                "Catalogue de Styles",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),

            // -------------------------------------------------------
            // 2. BARRE DE RECHERCHE
            // -------------------------------------------------------
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: TextField(
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: "Rechercher une coupe, un tag...",
                  hintStyle: const TextStyle(color: Colors.grey),
                  prefixIcon: const Icon(Icons.search, color: Colors.grey),
                  filled: true,
                  fillColor: AppTheme.cardLight, // Fond gris sombre
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide.none, // Pas de bordure visible
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // -------------------------------------------------------
            // 3. FILTRES (TAGS)
            // -------------------------------------------------------
            // SizedBox définit une hauteur fixe pour la liste horizontale
            SizedBox(
              height: 40, 
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: _filters.length,
                itemBuilder: (context, index) {
                  final isSelected = _selectedFilterIndex == index;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedFilterIndex = index),
                    child: Container(
                      margin: const EdgeInsets.only(right: 10),
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      decoration: BoxDecoration(
                        // Si sélectionné : un peu plus clair, sinon gris sombre
                        color: isSelected ? Colors.white24 : AppTheme.cardLight,
                        borderRadius: BorderRadius.circular(20),
                        // Bordure si non sélectionné (comme sur ta maquette "Afro", "Buzz Cut")
                        border: isSelected ? null : Border.all(color: Colors.white12),
                      ),
                      child: Text(
                        _filters[index].toUpperCase(), // Tout en majuscule
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.grey,
                          fontWeight: FontWeight.bold,
                          fontSize: 12
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            
            // J'ai supprimé la barre de scroll ici comme demandé

            const SizedBox(height: 20),

            // -------------------------------------------------------
            // 4. GRILLE DES STYLES
            // -------------------------------------------------------
            Expanded( // Expanded prend tout l'espace restant en bas
              child: GridView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // 2 colonnes
                  childAspectRatio: 0.7, // Ratio Hauteur/Largeur (0.7 rend les cartes plus hautes)
                  crossAxisSpacing: 15, // Espace horizontal entre les cartes
                  mainAxisSpacing: 20, // Espace vertical entre les cartes
                ),
                itemCount: _stylesData.length,
                itemBuilder: (context, index) {
                  return _buildStyleCard(_stylesData[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // -------------------------------------------------------
  // WIDGET : CARTE DE STYLE INDIVIDUELLE
  // -------------------------------------------------------
  Widget _buildStyleCard(Map<String, dynamic> style) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // PARTIE IMAGE (Le carré arrondi)
        Expanded( // L'image prend toute la place possible dans la colonne
          child: Stack(
            fit: StackFit.expand, // Force les enfants à prendre toute la place du stack
            children: [
              // 1. L'Image de fond
              ClipRRect( // Arrondit les bords de l'image
                borderRadius: BorderRadius.circular(20),
                child: Image.network(
                  style["image"],
                  fit: BoxFit.cover, // L'image couvre tout sans déformation
                ),
              ),
              
              // 2. Le Badge Catégorie (En haut à gauche)
              Positioned(
                top: 10,
                left: 10,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.6), // Fond noir semi-transparent
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    style["category"],
                    style: const TextStyle(
                      color: Colors.white, 
                      fontSize: 10, 
                      fontWeight: FontWeight.bold
                    ),
                  ),
                ),
              ),

              // 3. Le Bouton "ESSAYER" (Demande spécifique)
              // Centré en bas de l'image
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  margin: const EdgeInsets.only(bottom: 15), // Marge du bas
                  child: InkWell(
                    onTap: () {
                      print("Essayer ${style['name']}");
                      // Ici on ouvrira la caméra plus tard
                    },
                    borderRadius: BorderRadius.circular(30),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      decoration: BoxDecoration(
                        // Couleur blanche transparente (Glassmorphism)
                        color: Colors.white.withOpacity(0.25), 
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(color: Colors.white.withOpacity(0.4), width: 1.5),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 10,
                          )
                        ]
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min, // Taille minimum selon le contenu
                        children: const [
                          Icon(Icons.camera_alt_outlined, color: Colors.white, size: 16),
                          SizedBox(width: 8),
                          Text(
                            "Essayer",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 12
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),

        const SizedBox(height: 10), // Espace entre l'image et le texte

        // PARTIE TEXTE (Sous l'image)
        Text(
          style["name"], // "Mid Fade"
          style: const TextStyle(
            color: Colors.white, 
            fontWeight: FontWeight.bold, 
            fontSize: 16
          ),
        ),
        Text(
          style["tags"], // "#court #propre"
          style: const TextStyle(
            color: Colors.grey, 
            fontSize: 12
          ),
        ),
      ],
    );
  }
}