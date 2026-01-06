import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/app_theme.dart';
import 'auth/login_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  // LES DONNÉES DES 3 SLIDES
  final List<Map<String, String>> _onboardingData = [
    {
      "title": "Bienvenue sur AI Barber",
      "text": "Transformez votre look en quelques secondes grâce à l'intelligence artificielle.",
      "image": "https://images.unsplash.com/photo-1585747860715-2ba37e788b70?q=80&w=1000" // Image Barber Shop
    },
    {
      "title": "Choisissez votre Style",
      "text": "Accédez à un catalogue de coupes tendances : Buzz Cut, Afro, Waves, Dégradés...",
      "image": "https://images.unsplash.com/photo-1621605815971-fbc98d665033?q=80&w=1000" // Image Coupe
    },
    {
      "title": "Essayez avant de Couper",
      "text": "Visualisez le résultat sur votre propre visage avant d'aller chez le coiffeur.",
      "image": "https://images.unsplash.com/photo-1616091216791-a5360b5fc78a?q=80&w=1000" // Image Résultat
    },
  ];

  // Fonction pour finir l'intro
  Future<void> _finishOnboarding() async {
    // 1. On note dans le téléphone que l'intro est vue
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('seenOnboarding', true);

    // 2. On va à la page de connexion
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // 1. IMAGE DE FOND (PLEIN ÉCRAN)
          Positioned.fill(
            child: Image.network(
              _onboardingData[_currentPage]['image']!,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Container(color: Colors.black); // Fond noir pendant chargement
              },
            ),
          ),
          
          // 2. FILTRE SOMBRE (GRADIENT)
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.1),
                    Colors.black.withOpacity(0.6),
                    Colors.black.withOpacity(0.9), // Très sombre en bas pour le texte
                    Colors.black,
                  ],
                  stops: const [0.0, 0.4, 0.7, 1.0],
                ),
              ),
            ),
          ),

          // 3. CONTENU (TEXTE + BOUTONS)
          SafeArea(
            child: Column(
              children: [
                // Bouton "Passer" en haut à droite
                Align(
                  alignment: Alignment.topRight,
                  child: TextButton(
                    onPressed: _finishOnboarding,
                    child: const Text("PASSER", style: TextStyle(color: Colors.white70)),
                  ),
                ),
                
                const Spacer(), // Pousse tout vers le bas

                // PAGEVIEW (TEXTES)
                SizedBox(
                  height: 250,
                  child: PageView.builder(
                    controller: _pageController,
                    onPageChanged: (value) => setState(() => _currentPage = value),
                    itemCount: _onboardingData.length,
                    itemBuilder: (context, index) => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            _onboardingData[index]['title']!,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              height: 1.2,
                            ),
                          ),
                          const SizedBox(height: 15),
                          Text(
                            _onboardingData[index]['text']!,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 16,
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // INDICATEURS DE PAGE (LES POINTS)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    _onboardingData.length,
                    (index) => AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      height: 8,
                      width: _currentPage == index ? 24 : 8, // Le point actif est plus large
                      decoration: BoxDecoration(
                        color: _currentPage == index ? AppTheme.primaryPurple : Colors.white24,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                // GROS BOUTON D'ACTION
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                  child: SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_currentPage == _onboardingData.length - 1) {
                          _finishOnboarding(); // Si dernière page -> Finir
                        } else {
                          _pageController.nextPage( // Sinon -> Page suivante
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeIn,
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryPurple,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      ),
                      child: Text(
                        _currentPage == _onboardingData.length - 1 ? "COMMENCER" : "SUIVANT",
                        style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}