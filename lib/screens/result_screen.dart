import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:image_gallery_saver_plus/image_gallery_saver_plus.dart';

import 'package:permission_handler/permission_handler.dart';
import '../core/app_theme.dart';

class ResultScreen extends StatefulWidget {
  final String originalImageProvider; 
  final String generatedImageUrl;     
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
  bool _showTutorial = true;
  bool _isSaving = false; // Pour afficher un chargement pendant la sauvegarde

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) setState(() => _showTutorial = false);
    });
  }

  // --- 1. FONCTION DE PARTAGE ---
  Future<void> _shareImage() async {
    try {
      // Convertir le Base64 en fichier temporaire
      final bytes = _decodeBase64(widget.generatedImageUrl);
      if (bytes == null) return;

      final tempDir = await getTemporaryDirectory();
      final file = await File('${tempDir.path}/barber_ai_share.png').create();
      await file.writeAsBytes(bytes);

      // Partager le fichier
      await Share.shareXFiles(
        [XFile(file.path)], 
        text: 'Regarde mon nouveau style avec AI Barber ! 💈🔥'
      );
    } catch (e) {
      print("Erreur partage: $e");
    }
  }

  // --- 2. FONCTION DE SAUVEGARDE ---
  Future<void> _saveToGallery() async {
    setState(() => _isSaving = true);
    try {
      // Demander la permission (Android < 13 surtout)
      if (Platform.isAndroid) {
        await Permission.storage.request();
      }

      final bytes = _decodeBase64(widget.generatedImageUrl);
      if (bytes == null) throw Exception("Image invalide");

      final result = await ImageGallerySaverPlus.saveImage(
        bytes,
        quality: 100,
        name: "BarberAI_${DateTime.now().millisecondsSinceEpoch}"
      );

      bool isSuccess = result['isSuccess'] ?? false;
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(isSuccess ? '✅ Photo enregistrée dans la galerie !' : '❌ Erreur de sauvegarde'),
            backgroundColor: isSuccess ? Colors.green : Colors.red,
          )
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
           const SnackBar(content: Text('❌ Erreur technique'), backgroundColor: Colors.red)
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  // Helper pour décoder proprement
  Uint8List? _decodeBase64(String data) {
    try {
      if (data.startsWith('http')) return null; // Cas URL non géré ici pour le share rapide (à améliorer si besoin)
      String clean = data.contains(',') ? data.split(',').last : data;
      clean = clean.replaceAll(RegExp(r'\s+'), '');
      return base64Decode(clean);
    } catch (e) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(widget.styleName),
        backgroundColor: Colors.transparent,
        actions: [
          // Bouton Partager dans la barre du haut
          IconButton(
            icon: const Icon(Icons.share), 
            onPressed: _shareImage
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: InteractiveViewer(
              minScale: 1.0, maxScale: 4.0,
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
                        SizedBox(width: width, height: height, child: _buildResultImage(widget.generatedImageUrl)),
                        ClipRect(
                          clipper: _SliderClipper(_sliderValue),
                          child: SizedBox(width: width, height: height, child: Image.file(File(widget.originalImageProvider), fit: BoxFit.cover)),
                        ),
                        Positioned(
                          left: width * _sliderValue - 1.5, top: 0, bottom: 0,
                          child: Container(width: 3, color: Colors.white),
                        ),
                        // Indicateur de chargement si sauvegarde en cours
                        if (_isSaving)
                          Container(
                            color: Colors.black54,
                            child: const Center(child: CircularProgressIndicator(color: AppTheme.primaryPurple)),
                          )
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
          
          // BARRE D'ACTIONS DU BAS
          Container(
            padding: const EdgeInsets.all(20),
            color: AppTheme.cardDark,
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _saveToGallery,
                    icon: const Icon(Icons.download),
                    label: const Text("Enregistrer"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildResultImage(String data) {
    if (data.startsWith('http')) {
      return Image.network(data, fit: BoxFit.cover);
    } else if (data.length > 100) { 
      try {
        String cleanBase64 = data.contains(',') ? data.split(',').last : data;
        cleanBase64 = cleanBase64.replaceAll(RegExp(r'\s+'), '');
        return Image.memory(base64Decode(cleanBase64), fit: BoxFit.cover);
      } catch (e) {
        return const Center(child: Text("Erreur image", style: TextStyle(color: Colors.red)));
      }
    } else {
      return const Center(child: CircularProgressIndicator());
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