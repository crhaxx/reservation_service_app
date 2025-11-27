import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseService {
  static Future<User?> signUp(String email, String password) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      await saveUserData(userCredential.user!, "Nikola", "Test Value");
      return userCredential.user;
    } catch (e) {
      print("Error: $e");
      return null;
    }
  }

  static Future<User?> signIn(String email, String password) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final data = await getUserData(user);
        print("Username: ${data?['username']}");
      }

      return userCredential.user;
    } catch (e) {
      print("Error: $e");
      return null;
    }
  }

  static Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  static Future<void> saveUserData(
    User user,
    String username,
    String testvalue,
  ) async {
    await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
      'email': user.email,
      'username': username,
      'testvalue': testvalue,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  static Future<Map<String, dynamic>?> getUserData(User user) async {
    try {
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (doc.exists) {
        return doc.data() as Map<String, dynamic>;
      } else {
        print("No user document found for ${user.uid}");
        return null;
      }
    } catch (e) {
      print("Error fetching user data: $e");
      return null;
    }
  }
}
