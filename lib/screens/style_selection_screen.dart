import 'dart:io';
import 'package:barber_app/widgets/ai_loader.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../core/app_theme.dart';
import 'result_screen.dart'; // Nous allons créer ce fichier juste après
import '../../services/n8n_service.dart';
import '../../services/history_service.dart';
class StyleSelectionScreen extends StatelessWidget {
  final String imagePath; // La photo de l'utilisateur
   final N8nService _n8nService = N8nService();
  StyleSelectionScreen({super.key, required this.imagePath});

  // Données simulées (Mêmes que le catalogue)
  final List<Map<String, String>> _styles = [
    {"name": "Mid Fade", "image": "https://images.unsplash.com/photo-1621605815971-fbc98d665033?q=80&w=500"},
    {"name": "Short Afro", "image": "https://images.unsplash.com/photo-1621784564114-6deb2924d547?q=80&w=500"},
    {"name": "Cornrows", "image": "https://images.unsplash.com/photo-1517832606299-7ae9b720a186?q=80&w=500"},
    {"name": "Buzz Cut", "image": "https://images.unsplash.com/photo-1493246507139-91e8fad9978e?q=80&w=500"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Choisissez un style")),
      body: Column(
        children: [
          // Petit rappel de la photo uploadée
          Container(
            height: 100,
            width: double.infinity,
            color: AppTheme.cardLight,
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.file(File(imagePath), width: 80, height: 80, fit: BoxFit.cover),
                ),
                const SizedBox(width: 15),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Photo validée", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    Text("Sélectionnez la coupe à appliquer", style: TextStyle(color: Colors.grey, fontSize: 12)),
                  ],
                )
              ],
            ),
          ),
          
          // Grille de sélection
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(20),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.8,
                crossAxisSpacing: 15,
                mainAxisSpacing: 15,
              ),
              itemCount: _styles.length,
              itemBuilder: (context, index) {
                final style = _styles[index];
                return GestureDetector(
                  onTap: () {
                    // Petite vibration sèche et agréable
                    HapticFeedback.lightImpact(); 
                    // C'est ici qu'on lance la "Génération"
                    // On simule un chargement puis on va au résultat
                    _startGenerationProcess(context, style["name"]!);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      image: DecorationImage(
                        image: NetworkImage(style["image"]!),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Colors.transparent, Colors.black.withOpacity(0.8)],
                        ),
                      ),
                      alignment: Alignment.bottomCenter,
                      padding: const EdgeInsets.all(10),
                      child: Text(
                        style["name"]!,
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _startGenerationProcess(BuildContext context, String styleName) async {
    HapticFeedback.lightImpact();

    // Loader
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.8),
      builder: (context) => const AiLoader(),
    );

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) throw Exception("Utilisateur non connecté");

      // 1. APPEL IA (n8n)
      String generatedUrl = await _n8nService.generateHairstyle(
        imagePath: imagePath,
        style: styleName,
        userId: user.uid,
      );

      // 2. SAUVEGARDE AUTOMATIQUE (Nouveau !)
      // On le fait en "arrière-plan" sans attendre (await) pour ne pas ralentir l'affichage
      HistoryService().saveGeneration(
        userId: user.uid,
        styleName: styleName,
        imageData: generatedUrl
      );

      // 3. NAVIGATION
      if (context.mounted) {
        Navigator.pop(context); // Ferme loader
        HapticFeedback.mediumImpact();

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ResultScreen(
              styleName: styleName,
              originalImageProvider: imagePath, 
              generatedImageUrl: generatedUrl, 
            ),
          ),
        );
      }

    } catch (e) {
      if (context.mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Erreur : $e"), backgroundColor: Colors.red)
        );
      }
    }
  }
}