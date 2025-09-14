import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;


  Future<User?> signIn(String email, String password) async {
    final result = await _auth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
    return result.user;
  }


  Future<User?> register(String email, String password, String username) async {
    try {

      if (email.trim().isEmpty) throw ArgumentError('Email cannot be empty');
      if (password.length < 6)
        throw ArgumentError('Password must be at least 6 characters');
      if (username.trim().isEmpty)
        throw ArgumentError('Username/display name cannot be empty');

      final result = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      final user = result.user;

      if (user != null) {

        await user.updateDisplayName(username.trim());

        await user.reload();
      }

      return user;
    } on FirebaseAuthException {
      rethrow;
    } catch (e) {
      rethrow;
    }
  }


  Future<void> signOut() async {
    await _auth.signOut();
  }


  User? get currentUser => _auth.currentUser;


  Future<void> deleteCurrentUser() async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('No user is signed in');
    await user.delete();
  }


  Future<void> updatePassword(String newPassword) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('No user is signed in');
    if (newPassword.length < 6)
      throw ArgumentError('Password must be at least 6 characters');
    await user.updatePassword(newPassword);
  }


  Future<void> sendEmailVerification() async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('No user is signed in');
    await user.sendEmailVerification();
  }


  Future<void> updateEmail(String newEmail) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('No user is signed in');
    if (newEmail.trim().isEmpty) throw ArgumentError('Email cannot be empty');
    await user.verifyBeforeUpdateEmail(newEmail.trim());
  }


  Future<void> sendPasswordResetEmail(String email) async {
    if (email.trim().isEmpty) throw ArgumentError('Email cannot be empty');
    await _auth.sendPasswordResetEmail(email: email.trim());
  }


  Future<void> updateDisplayName(String newDisplayName) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('No user is signed in');
    if (newDisplayName.trim().isEmpty) {
      throw ArgumentError('Display name cannot be empty');
    }
    
    await user.updateDisplayName(newDisplayName.trim());
    await user.reload(); // Sync local user object with updated profile
  }
}

