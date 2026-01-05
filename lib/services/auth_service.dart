import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // 1. Inscription (Sign Up)
  Future<User?> signUp({required String email, required String password, required String name}) async {
    try {
      // Créer l'utilisateur dans Firebase Auth
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      User? user = result.user;

      // Sauvegarder le Nom + Email dans Firestore (Base de données)
      if (user != null) {
        await _firestore.collection('users').doc(user.uid).set({
          'uid': user.uid,
          'name': name,
          'email': email,
          'credits': 5, // On offre 5 crédits à l'inscription
          'isPro': false,
          'createdAt': FieldValue.serverTimestamp(),
        });
      }
      
      return user;
    } on FirebaseAuthException catch (e) {
      throw e.message ?? "Une erreur est survenue lors de l'inscription.";
    }
  }

  // 2. Connexion (Login)
  Future<User?> signIn({required String email, required String password}) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return result.user;
    } on FirebaseAuthException catch (e) {
      throw e.message ?? "Erreur de connexion.";
    }
  }

  // 3. Déconnexion
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // 4. Obtenir l'utilisateur actuel
  User? getCurrentUser() {
    return _auth.currentUser;
  }
}