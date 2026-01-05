import 'dart:io';
import 'package:flutter/material.dart';
import '../core/app_theme.dart';

class ResultScreen extends StatefulWidget {
  final String originalImageProvider; // Peut être un chemin de fichier OU une URL
  final String generatedImageUrl;     // L'image résultat (URL)
  final String styleName;
  final String? heroTag; 


  const ResultScreen({
    super.key, 
    required this.originalImageProvider, 
    required this.generatedImageUrl,
    required this.styleName,
    this.heroTag,
  });

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  double _sliderValue = 0.5;
  bool _showTutorial = true; // Pour afficher/cacher le tuto

  @override
  void initState() {
    super.initState();
    // Cache le tutoriel automatiquement après 3 secondes
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _showTutorial = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(widget.styleName),
        actions: [
          IconButton(icon: const Icon(Icons.share), onPressed: () {}),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: InteractiveViewer( // Le ZOOM est ici
              minScale: 1.0,
              maxScale: 4.0,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final width = constraints.maxWidth;
                  final height = constraints.maxHeight;

                  return GestureDetector(
                    onHorizontalDragUpdate: (details) {
                      setState(() {
                        _sliderValue += details.delta.dx / width;
                        _sliderValue = _sliderValue.clamp(0.0, 1.0);
                      });
                    },
                    child: Stack(
                      children: [
                        // 1. IMAGE APRÈS (Dessous)
                        SizedBox(
                          width: width, height: height,
                          child: widget.heroTag != null 
                              ? Hero(tag: widget.heroTag!, child: _buildImage(widget.generatedImageUrl))
                              : _buildImage(widget.generatedImageUrl),
                        ),

                        // 2. IMAGE AVANT (Dessus, coupée)
                        ClipRect(
                          clipper: _SliderClipper(_sliderValue),
                          child: SizedBox(
                            width: width, height: height,
                            child: _buildImage(widget.originalImageProvider),
                          ),
                        ),

                        // 3. LA BARRE DU SLIDER
                        Positioned(
                          left: width * _sliderValue - 1.5,
                          top: 0, bottom: 0,
                          child: Container(
                            width: 3, color: Colors.white,
                            child: Center(
                              child: Container(
                                width: 30, height: 30,
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                  boxShadow: [BoxShadow(blurRadius: 10, color: Colors.black45)]
                                ),
                                child: const Icon(Icons.compare_arrows, size: 20, color: AppTheme.primaryPurple),
                              ),
                            ),
                          ),
                        ),
                      
                      // 5. TUTORIEL OVERLAY (COUCHE D'AIDE)
                        IgnorePointer( // Permet de cliquer à travers le tuto
                          child: AnimatedOpacity(
                            duration: const Duration(milliseconds: 500),
                            opacity: _showTutorial ? 1.0 : 0.0,
                            child: Container(
                              color: Colors.black.withOpacity(0.4), // Fond sombre léger
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    // Icône de glissement
                                    const Icon(Icons.touch_app, color: Colors.white, size: 50),
                                    const SizedBox(height: 10),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: const [
                                        Icon(Icons.arrow_back, color: Colors.white),
                                        SizedBox(width: 10),
                                        Text(
                                          "GLISSEZ POUR COMPARER",
                                          style: TextStyle(
                                            color: Colors.white, 
                                            fontWeight: FontWeight.bold,
                                            letterSpacing: 2
                                          ),
                                        ),
                                        SizedBox(width: 10),
                                        Icon(Icons.arrow_forward, color: Colors.white),
                                      ],
                                    ),
                                    const SizedBox(height: 30),
                                    // Icône de Zoom
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: const [
                                        Icon(Icons.zoom_in, color: AppTheme.primaryPurple),
                                        SizedBox(width: 10),
                                        Text(
                                          "PINCEZ POUR ZOOMER",
                                          style: TextStyle(color: AppTheme.primaryPurple, fontSize: 12),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      
                      ],

                      
                    ),
                  );
                },
              ),
            ),
          ),
          
          // Boutons du bas (cachés si on vient de la galerie pour simplifier, ou gardés)
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  // Fonction intelligente pour afficher l'image selon si c'est une URL ou un Fichier
  Widget _buildImage(String path) {
    if (path.startsWith('http')) {
      // C'est une URL (Galerie)
      return Image.network(path, fit: BoxFit.contain);
    } else {
      // C'est un fichier local (Caméra)
      return Image.file(File(path), fit: BoxFit.contain);
    }
  }
}

class _SliderClipper extends CustomClipper<Rect> {
  final double value;
  _SliderClipper(this.value);
  @override
  Rect getClip(Size size) => Rect.fromLTRB(0, 0, size.width * value, size.height);
  @override
  bool shouldReclip(covariant CustomClipper<Rect> oldClipper) => true;
}