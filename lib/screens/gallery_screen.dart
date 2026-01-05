import 'package:barber_app/widgets/shimmer_image.dart';
import 'package:flutter/material.dart';
import '../core/app_theme.dart';
import 'result_screen.dart';
class GalleryScreen extends StatefulWidget {
  const GalleryScreen({super.key});

  @override
  State<GalleryScreen> createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  // ---------------------------------------------------------------------------
  // DONNÉES SIMULÉES (MOCK DATA)
  // ---------------------------------------------------------------------------
  final List<Map<String, dynamic>> _historyItems = [
    {
      "id": 1,
      "style": "Mid Fade",
      "date": "Aujourd'hui, 14:30",
      // Image finale (Après)
      "image": "https://images.unsplash.com/photo-1621605815971-fbc98d665033?q=80&w=1000", 
      // Image originale (Avant) - Je mets une autre image pour qu'on voit la différence
      "original": "https://images.unsplash.com/photo-1595152772835-219674b2a8a6?q=80&w=1000" 
    },
    {
      "id": 2,
      "style": "Buzz Cut",
      "date": "Hier, 09:15",
      "image": "https://images.unsplash.com/photo-1493246507139-91e8fad9978e?q=80&w=1000",
      "original": "https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?q=80&w=1000"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Mes Simulations", style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: false, // Titre aligné à gauche
        actions: [
          // Bouton "Tout supprimer" (Optionnel)
          IconButton(
            icon: const Icon(Icons.delete_outline, color: Colors.grey),
            onPressed: () {
               // Action de nettoyage
            },
          )
        ],
      ),
      body: _historyItems.isEmpty 
          ? _buildEmptyState() // Si la liste est vide
          : _buildGalleryList(), // Si la liste contient des éléments
    );
  }

  // -------------------------------------------------------
  // VUE LISTE (Quand il y a des photos)
  // -------------------------------------------------------
  Widget _buildGalleryList() {
    return ListView.separated(
      padding: const EdgeInsets.all(20),
      itemCount: _historyItems.length,
      separatorBuilder: (context, index) => const SizedBox(height: 30), // Espace entre les cartes
      itemBuilder: (context, index) {
        return _buildHistoryCard(_historyItems[index]);
      },
    );
  }

  // -------------------------------------------------------
  // VUE VIDE (Quand il n'y a pas encore de photos)
  // -------------------------------------------------------
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.history, size: 80, color: AppTheme.cardLight),
          const SizedBox(height: 20),
          const Text(
            "Aucune simulation",
            style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          const Text(
            "Vos futures coiffures apparaîtront ici.",
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }

  // -------------------------------------------------------
  // WIDGET : CARTE D'HISTORIQUE
  // -------------------------------------------------------
  Widget _buildHistoryCard(Map<String, dynamic> item) {
    return GestureDetector(
      // --- C'EST ICI QUE SE PASSE L'ACTION ---
      onTap: () {
        // On navigue vers l'écran de résultat (Le visualiseur)
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ResultScreen(
              styleName: item["style"],
              originalImageProvider: item["original"], // URL de l'image originale
              generatedImageUrl: item["image"],  
              heroTag: 'image_${item["id"]}',      // URL de l'image générée
            ),
          ),
        );
      },
      // ----------------------------------------
      
      child: Container(
        decoration: BoxDecoration(
          color: AppTheme.cardDark,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // IMAGE + BADGE
            Stack(
              children: [
                Hero(
                tag: 'image_${item["id"]}', // Tag unique indispensable
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                  child: AspectRatio(
                    aspectRatio: 4 / 3,
                    child: Image.network(
                      item["image"],
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return const Center(child: ShimmerLoading(width: 1000, height: 1000,));
                      },
                    ),
                  ),
                ),
                ),
                // Badge
                Positioned(
                  top: 15, left: 15,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      item["style"].toUpperCase(),
                      style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                // Petit indicateur "Voir" au centre (Optionnel, pour montrer que c'est cliquable)
                Positioned.fill(
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.3),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white30)
                      ),
                      child: const Icon(Icons.zoom_in, color: Colors.white, size: 24),
                    ),
                  ),
                )
              ],
            ),

            // BARRE BAS
            Padding(
              padding: const EdgeInsets.all(15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(item["date"], style: const TextStyle(color: AppTheme.textGrey, fontSize: 12)),
                  const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey)
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
  
  
  // Petit widget helper pour les boutons ronds
  Widget _buildActionButton(IconData icon, VoidCallback onTap, {Color? color}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppTheme.cardLight, // Fond du bouton
          shape: BoxShape.circle,
        ),
        child: Icon(icon, size: 20, color: color ?? Colors.white),
      ),
    );
  }
}