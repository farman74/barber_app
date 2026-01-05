import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class N8nService {
  // ⚠️ Remplace ceci par l'URL de ton Webhook de Production n8n
  // Exemple: "https://mon-n8n.com/webhook/generation-coiffure"
  final String _webhookUrl = "https://tucker-moanful-silvana.ngrok-free.dev/webhook-test/generation-coiffure";

  /// Envoie la photo et les infos à n8n et attend le résultat
  Future<String> generateHairstyle({
    required String imagePath,
    required String style,
    required String userId,
  }) async {
    try {
      // 1. Création de la requête Multipart (pour envoyer un fichier)
      var request = http.MultipartRequest('POST', Uri.parse(_webhookUrl));

      // 2. Ajout des champs textes (Métadonnées)
      request.fields['user_id'] = userId;
      request.fields['style'] = style; // ex: "Mid Fade"

      // 3. Ajout du fichier image
      request.files.add(await http.MultipartFile.fromPath(
        'image', // Le nom du champ que n8n devra lire (Binary Property)
        imagePath,
      ));

      // 4. Envoi de la requête
      print("🚀 Envoi vers n8n en cours...");
      var streamedResponse = await request.send();

      // 5. Lecture de la réponse
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        // On suppose que n8n renvoie un JSON : { "result_url": "https://..." }
        final data = jsonDecode(response.body);
        print("✅ Réponse n8n reçue");
        return data['result_url']; 
      } else {
        throw Exception("Erreur n8n (${response.statusCode}): ${response.body}");
      }
    } catch (e) {
      print("❌ Erreur connexion n8n: $e");
      throw Exception("Impossible de contacter le serveur IA.");
    }
  }
}