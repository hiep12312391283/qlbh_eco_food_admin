import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth auth = FirebaseAuth.instance;

  Future<void> signUpWithEmailPassword(String email, String password) async {
    try {
      UserCredential userCredential =
          await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      // Gửi email xác nhận
      await userCredential.user?.sendEmailVerification();
    } catch (e) {
      print("Lỗi: $e");
      throw e;
    }
  }

  Future<User?> signInWithEmailPassword(String email, String password) async {
    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user != null && userCredential.user!.emailVerified) {
        return userCredential.user;
      } else {
        await auth.signOut();
        return null;
      }
    } catch (e) {
      print("Lỗi: $e");
      throw e;
    }
  }
  Future<void> deleteAccount() async {
    try {
      final user = auth.currentUser;
      if (user != null) {
        // Xóa tài khoản trên Firebase Authentication
        await user.delete();
        print("Account deleted successfully from Firebase Authentication.");
      } else {
        print("No user is logged in.");
      }
    } catch (e) {
      print("Error deleting account: $e");
      throw e;
    }
  }
}
