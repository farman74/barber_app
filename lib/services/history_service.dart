import 'dart:convert';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class HistoryService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // Sauvegarde une génération dans l'historique
  Future<void> saveGeneration({
    required String userId,
    required String styleName,
    required String imageData, // Peut être une URL ou du Base64
  }) async {
    try {
      String imageUrl = imageData;

      // SI C'EST DU BASE64 (Texte) -> ON DOIT L'UPLOADER SUR STORAGE
      if (!imageData.startsWith('http')) {
        print("💾 Upload de l'image Base64 vers Firebase Storage...");
        imageUrl = await _uploadBase64Image(userId, imageData);
      }

      // SAUVEGARDE DANS FIRESTORE
      await _firestore.collection('users').doc(userId).collection('history').add({
        'style': styleName,
        'imageUrl': imageUrl,
        'createdAt': FieldValue.serverTimestamp(),
        'isFavorite': false,
      });
      
      print("✅ Génération sauvegardée dans l'historique !");
    } catch (e) {
      print("❌ Erreur sauvegarde historique: $e");
      // On ne bloque pas l'app si la sauvegarde échoue, on log juste l'erreur
    }
  }

  // Helper pour uploader le Base64
  Future<String> _uploadBase64Image(String userId, String base64String) async {
    // 1. Nettoyage du Base64
    String cleanBase64 = base64String;
    if (cleanBase64.contains(',')) {
      cleanBase64 = cleanBase64.split(',').last;
    }
    cleanBase64 = cleanBase64.replaceAll(RegExp(r'\s+'), '');
    
    // 2. Conversion en bytes
    Uint8List data = base64Decode(cleanBase64);
    
    // 3. Création du chemin de fichier unique
    String fileName = "${DateTime.now().millisecondsSinceEpoch}.jpg";
    Reference ref = _storage.ref().child('users/$userId/generations/$fileName');
    
    // 4. Upload
    UploadTask task = ref.putData(data, SettableMetadata(contentType: 'image/jpeg'));
    TaskSnapshot snapshot = await task;
    
    // 5. Récupération de l'URL publique
    return await snapshot.ref.getDownloadURL();
  }
  
  // Récupérer l'historique (Stream pour mise à jour en temps réel)
  Stream<QuerySnapshot> getUserHistory(String userId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('history')
        .orderBy('createdAt', descending: true) // Les plus récents en premier
        .snapshots();
  }
}