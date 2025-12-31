import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/legacy.dart';

class AuthNotifier extends StateNotifier<User?> {
  final FirebaseAuth _auth = FirebaseAuth.instance; 
  
  AuthNotifier() : super(null) {
    _auth.authStateChanges().listen((user) {
      state = user;
    });
  }

  Stream<User?> get streamAuthStatus => _auth.authStateChanges();

  Future<String?> login(String email, String pass) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: pass,
      );
      return null; // null = sukses
      if (credential.user!.emailVerified) {
        return null;
      } else {
        return "Harap Verifikasi Email terlebih dahulu !";
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return "Email tidak ditemukan.";
      } else if (e.code == 'wrong-password') {
        return "Password salah.";
      } else {
        return e.message;
      }
    }
  }
  Future<String?> signup(String email, String password) async {
    try {
      UserCredential myUser = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await myUser.user!.sendEmailVerification();
      return null;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return "Password terlalu lemah.";
      } else if (e.code == 'email-already-in-use') {
        return "Email sudah terdaftar.";
      } else {
        return e.toString();
      }
    } catch (e) {
      return e.toString();
    }
  }

  Future<void> Logout() async {
    await _auth.signOut();
  }

  Future<String?> ResetPassword(String email) async {
   if (email.isEmpty) return "email tidak boleh kosong"; 
   if (!email.contains("@")) return "Email tidak valid"; 

   try {
    await _auth.sendPasswordResetEmail(email: email);
    return null;
  } catch (e) {
    return "Gagal Mengirimkan reset password";
   }
  }
}


final authProvider = StateNotifierProvider<AuthNotifier, User?>(
  (ref) => AuthNotifier(),
);