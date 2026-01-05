// Fichier : lib/core/app_theme.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // ---------------------------------------------------------------------------
  // PALETTE DE COULEURS (Basée sur tes maquettes "Cyber-Barber")
  // ---------------------------------------------------------------------------
  
  // Fond noir profond (pour écrans OLED)
  static const Color background = Color(0xFF050505);
  
  // Couleur des cartes et conteneurs (Gris anthracite très sombre)
  static const Color cardDark = Color(0xFF121212);
  
  // Couleur des éléments un peu plus clairs (Champs de texte, cartes secondaires)
  static const Color cardLight = Color(0xFF1E1E1E);
  
  // LA couleur d'accentuation (Le Violet Néon de ton design)
  static const Color primaryPurple = Color(0xFF6C5DD3);
  
  // Couleur secondaire (pour les dégradés ou boutons secondaires)
  static const Color accentBlue = Color(0xFF4A00E0);

  // Textes
  static const Color textWhite = Colors.white;       // Titres
  static const Color textGrey = Color(0xFFB3B3B3);   // Sous-titres
  
  // ---------------------------------------------------------------------------
  // CONFIGURATION DU THÈME GLOBAL
  // ---------------------------------------------------------------------------
  static ThemeData get darkTheme {
    return ThemeData(
      // On force le mode sombre
      brightness: Brightness.dark,
      
      // Couleur de fond de toute l'application
      scaffoldBackgroundColor: background,
      
      // Définition de la couleur primaire
      primaryColor: primaryPurple,
      
      // Configuration de la police d'écriture (Poppins est moderne et géométrique)
      textTheme: GoogleFonts.poppinsTextTheme(ThemeData.dark().textTheme),
      
      // Utilisation du dernier standard de design Android
      useMaterial3: true,
      
      // Style par défaut des AppBar (Barres de titre)
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent, // Transparent par défaut
        elevation: 0, // Pas d'ombre
        centerTitle: true,
      ),

      // Style par défaut des boutons élevés (Pleins)
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryPurple,
          foregroundColor: textWhite,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          elevation: 5,
          shadowColor: primaryPurple.withOpacity(0.4), // Ombre violette lumineuse
        ),
      ),

      // Style de la barre de navigation en bas
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: cardDark,
        selectedItemColor: primaryPurple,
        unselectedItemColor: textGrey,
        type: BottomNavigationBarType.fixed, // Les icônes ne bougent pas
        showSelectedLabels: true,
        showUnselectedLabels: true,
        selectedLabelStyle: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
        unselectedLabelStyle: TextStyle(fontSize: 10),
      ),
    );
  }
}