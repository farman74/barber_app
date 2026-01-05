import 'dart:async';
import 'package:flutter/material.dart';
import '../core/app_theme.dart';

class AiLoader extends StatefulWidget {
  const AiLoader({super.key});

  @override
  State<AiLoader> createState() => _AiLoaderState();
}

class _AiLoaderState extends State<AiLoader> {
  int _step = 0;
  
  // Le scénario de chargement pour faire patienter
  final List<String> _steps = [
    "Analyse de la morphologie...",
    "Détection des contours du visage...",
    "Application de la texture de cheveux...",
    "Ajustement de l'éclairage studio...",
    "Finalisation du rendu HD..."
  ];

  late Timer _timer;

  @override
  void initState() {
    super.initState();
    // Change de message toutes les 1.5 secondes
    _timer = Timer.periodic(const Duration(milliseconds: 1500), (timer) {
      if (mounted) {
        setState(() {
          // On boucle sur les messages ou on reste sur le dernier
          if (_step < _steps.length - 1) {
            _step++;
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel(); // Très important : arrêter le timer quand on ferme le loader
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 300, // Largeur fixe pour éviter que ça bouge trop
        padding: const EdgeInsets.all(30),
        decoration: BoxDecoration(
          color: AppTheme.cardDark,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppTheme.primaryPurple.withOpacity(0.3)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.5),
              blurRadius: 30,
              spreadRadius: 5
            )
          ]
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Animation personnalisée (Cercle qui respire)
            const SizedBox(
              height: 50, width: 50,
              child: CircularProgressIndicator(
                color: AppTheme.primaryPurple,
                strokeWidth: 4,
                backgroundColor: Colors.white10,
              ),
            ),
            const SizedBox(height: 30),
            
            // Texte animé
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 500), // Transition douce
              child: Text(
                _steps[_step],
                key: ValueKey<int>(_step), // Clé unique pour forcer l'animation
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  height: 1.5
                ),
              ),
            ),
            
            const SizedBox(height: 15),
            
            // Barre de progression linéaire en bas
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(
                value: (_step + 1) / _steps.length, // Progression basée sur l'étape
                backgroundColor: Colors.white10,
                color: AppTheme.primaryPurple,
                minHeight: 4,
              ),
            )
          ],
        ),
      ),
    );
  }
}