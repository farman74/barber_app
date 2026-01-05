// Fichier : lib/screens/main_container.dart

import 'package:barber_app/screens/gallery_screen.dart';
import 'package:barber_app/screens/styles_screen.dart';
import 'package:flutter/material.dart';
import '../core/app_theme.dart';
import 'home_screen.dart';
import 'profile_screen.dart';
import 'package:image_picker/image_picker.dart'; // Pour la caméra
import 'image_validation_screen.dart'; // Pour l'écran qu'on vient de créer
// --- IMPORTATION DES ÉCRANS FUTURS ---
// Une fois que nous aurons créé les vrais fichiers (home_screen.dart, etc.), 
// nous changerons ces imports. Pour l'instant, je crée les classes vides en bas du fichier.

class MainContainer extends StatefulWidget {
  const MainContainer({super.key});

  @override
  State<MainContainer> createState() => _MainContainerState();
}

class _MainContainerState extends State<MainContainer> {
  // Index de la page actuelle (0 = Accueil)
  int _currentIndex = 0;

  // Liste des pages disponibles
  final List<Widget> _pages = [
    const HomeScreen(),    // Index 0: Accueil
    const GalleryScreen(), // Index 1: Galerie
    const SizedBox(),                 // Index 2: Vide (car c'est le bouton central +)
    const StylesScreen(),  // Index 3: Styles
    const ProfileScreen(), // Index 4: Profil
  ];

  // Fonction pour changer de page lors du clic sur une icône
  void _onTabTapped(int index) {
    if (index == 2) {
      // Si on clique sur l'index 2 (l'espace du milieu), on ne fait rien 
      // car le bouton "+" flottant gère cette action.
      return; 
    }
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Affiche la page correspondant à l'index actuel
      // Si l'index est 2 (le bouton +), on reste sur la page précédente pour éviter un écran blanc
      body: _pages[_currentIndex == 2 ? 0 : _currentIndex],

      // --- LE BOUTON CENTRAL FLOTTANT (+) ---
      floatingActionButton: Container(
        height: 70,
        width: 70,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          // Ombre lumineuse violette ("Glow effect")
          boxShadow: [
            BoxShadow(
              color: AppTheme.primaryPurple.withOpacity(0.4),
              blurRadius: 15,
              spreadRadius: 2,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: FloatingActionButton(
          backgroundColor: AppTheme.primaryPurple,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
          elevation: 0,
          onPressed: () {
            // C'est ici qu'on déclenchera l'ouverture de la caméra ou de la modale
            print("Action: Ouvrir le menu de création IA");
            _showUploadModal(context); // Fonction simulée plus bas
          },
          child: const Icon(Icons.add, size: 35, color: Colors.white),
        ),
      ),
      // Positionne le bouton au centre, encastré dans la barre
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      // --- LA BARRE DE NAVIGATION (BOTTOM BAR) ---
      bottomNavigationBar: BottomAppBar(
        color: AppTheme.cardDark,
        shape: const CircularNotchedRectangle(), // Crée l'encoche pour le bouton rond
        notchMargin: 8.0, // Marge entre le bouton et la barre
        child: SizedBox(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Partie Gauche
              _buildNavItem(Icons.home_filled, "Accueil", 0),
              _buildNavItem(Icons.history, "Galerie", 1),
              
              // Espace vide au milieu pour laisser la place au gros bouton "+"
              const SizedBox(width: 40), 
              
              // Partie Droite
              _buildNavItem(Icons.content_cut, "Styles", 3),
              _buildNavItem(Icons.person_outline, "Profil", 4),
            ],
          ),
        ),
      ),
    );
  }

  // Widget utilitaire pour créer un item de navigation
  Widget _buildNavItem(IconData icon, String label, int index) {
    final bool isSelected = _currentIndex == index;
    
    return InkWell(
      onTap: () => _onTabTapped(index),
      borderRadius: BorderRadius.circular(10),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon, 
              // Change la couleur si sélectionné
              color: isSelected ? AppTheme.primaryPurple : AppTheme.textGrey,
              size: 26,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                color: isSelected ? AppTheme.primaryPurple : AppTheme.textGrey,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            )
          ],
        ),
      ),
    );
  }

  
  // Instance de l'outil de capture d'image
  final ImagePicker _picker = ImagePicker();

  // Fonction pour gérer la prise de photo
  Future<void> _handleImageSelection(BuildContext context, ImageSource source) async {
    try {
      // 1. Ouvre la caméra ou la galerie
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        maxWidth: 1080, // Optimisation : on réduit un peu la taille pour l'upload
        maxHeight: 1080,
      );

      // 2. Si l'utilisateur a pris une photo (n'a pas annulé)
      if (pickedFile != null) {
        // Ferme la modale
        Navigator.pop(context);
        
        // 3. Navigue vers l'écran de validation
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ImageValidationScreen(imagePath: pickedFile.path),
          ),
        );
      }
    } catch (e) {
      print("Erreur lors de la sélection d'image : $e");
    }
  }

  // LA MODALE DE SÉLECTION (Design conforme à ta capture)
  void _showUploadModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent, // Transparent pour voir les coins arrondis
      builder: (context) => Container(
        height: 350,
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: AppTheme.cardDark,
          borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Petite barre grise en haut pour indiquer qu'on peut glisser
            Center(
              child: Container(
                width: 40, height: 4,
                decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(2)),
              ),
            ),
            const SizedBox(height: 20),
            
            // Titre
            const Text("Importez votre photo", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
            const SizedBox(height: 10),
            const Text(
              "Prenez un selfie clair, de face, avec une bonne luminosité pour un meilleur résultat.",
              style: TextStyle(color: Colors.grey, fontSize: 13),
            ),

            const SizedBox(height: 30),

            // GRILLE DES OPTIONS (Caméra / Galerie)
            Row(
              children: [
                // Option 1 : Caméra
                Expanded(
                  child: InkWell(
                    onTap: () => _handleImageSelection(context, ImageSource.camera),
                    child: Container(
                      height: 120,
                      decoration: BoxDecoration(
                        color: AppTheme.cardLight,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: AppTheme.primaryPurple.withOpacity(0.5)), // Bordure violette
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.camera_alt_outlined, size: 40, color: AppTheme.primaryPurple),
                          SizedBox(height: 10),
                          Text("Ouvrir la caméra", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 15),
                // Option 2 : Galerie
                Expanded(
                  child: InkWell(
                    onTap: () => _handleImageSelection(context, ImageSource.gallery),
                    child: Container(
                      height: 120,
                      decoration: BoxDecoration(
                        color: AppTheme.cardLight,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.white10),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.photo_library_outlined, size: 40, color: Colors.white),
                          SizedBox(height: 10),
                          Text("Depuis la galerie", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Conseil du bas
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTheme.primaryPurple.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppTheme.primaryPurple.withOpacity(0.3)),
              ),
              child: Row(
                children: const [
                  Icon(Icons.info_outline, color: AppTheme.primaryPurple, size: 20),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      "ASTUCE : Évitez les lunettes de soleil et les cheveux trop ébouriffés.",
                      style: TextStyle(color: AppTheme.primaryPurple, fontSize: 10, fontWeight: FontWeight.bold),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}





