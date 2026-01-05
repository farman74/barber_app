import 'dart:io'; // Nécessaire pour gérer les fichiers locaux
import 'package:barber_app/screens/style_selection_screen.dart';
import 'package:flutter/material.dart';
import '../core/app_theme.dart';

class ImageValidationScreen extends StatelessWidget {
  final String imagePath; // Le chemin de la photo prise

  const ImageValidationScreen({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("Validation"),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context), // Annuler et retour
        ),
      ),
      body: Column(
        children: [
          // 1. LA PHOTO (Prend toute la place disponible)
          Expanded(
            child: Container(
              width: double.infinity,
              margin: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                image: DecorationImage(
                  image: FileImage(File(imagePath)), // Charge l'image depuis le téléphone
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),

          // 2. CONSEILS DE QUALITÉ
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: const [
                Icon(Icons.check_circle, color: Colors.green, size: 20),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    "Assurez-vous que votre visage est bien éclairé et sans accessoires (lunettes, chapeau).",
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // 3. BOUTONS D'ACTION
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                // Bouton "Refaire"
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      side: const BorderSide(color: Colors.white30),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    ),
                    child: const Text("Refaire", style: TextStyle(color: Colors.white)),
                  ),
                ),
                const SizedBox(width: 15),
                // Bouton "Valider"
                // Bouton "Générer mon style"
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      // MODIFICATION ICI : On va vers le choix du style
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => StyleSelectionScreen(imagePath: imagePath),
                        ),
                      );
                    },
                    // ... style ...
                    child: const Text("Générer mon style", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}