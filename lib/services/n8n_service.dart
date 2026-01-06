import 'dart:convert';
import 'package:http/http.dart' as http;

class N8nService {
  // ⚠️ Vérifie que c'est bien ton URL ngrok ACTUELLE
  final String _webhookUrl = "https://tucker-moanful-silvana.ngrok-free.dev/webhook-test/generation-coiffure";

  Future<String> generateHairstyle({
    required String imagePath,
    required String style,
    required String userId,
  }) async {
    try {
      var request = http.MultipartRequest('POST', Uri.parse(_webhookUrl));
      request.fields['user_id'] = userId;
      request.fields['style'] = style; 
      request.files.add(await http.MultipartFile.fromPath('image', imagePath));

      print("🚀 Envoi vers n8n...");
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print("✅ Réponse n8n reçue !");
        
        // CORRECTION MAJEURE : On gère les deux cas (URL ou Base64)
        String result = data['image_base64'] ?? data['result_url'] ?? "";
        
        if (result.isEmpty) {
          throw Exception("L'IA n'a renvoyé aucune image valide.");
        }
        return result;
      } else {
        throw Exception("Erreur n8n (${response.statusCode}): ${response.body}");
      }
    } catch (e) {
      print("❌ Erreur: $e");
      throw Exception("Erreur technique: Impossible de joindre l'IA.");
    }
  }
}