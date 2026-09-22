import 'package:google_sign_in/google_sign_in.dart';
import 'package:news/core/constants/app_secrets.dart';
import 'package:news/core/exceptions/authentication_exception.dart';
import 'package:news/data/models/login_credential.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:news/data/models/sign_up_credential.dart';

class AuthenticationRepository {
  User? get currentUser => FirebaseAuth.instance.currentUser;

  Future<UserCredential> login(LoginCredential loginCredential) async {
    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: loginCredential.email,
        password: loginCredential.password,
      );
      return credential;
    } on FirebaseAuthException catch (e) {
      throw AuthenticationException.fromFirebase(e);
    } catch (e) {
      throw AuthenticationException('Authentication failed.');
    }
  }

  Future<UserCredential> signUp(SignUpCredential signUpCredential) async {
    try {
      final credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
            email: signUpCredential.email,
            password: signUpCredential.password,
          );
      await credential.user?.updateDisplayName(signUpCredential.name);

      return credential;
    } on FirebaseAuthException catch (e) {
      throw AuthenticationException.fromFirebase(e);
    } catch (e) {
      throw AuthenticationException('Authentication failed.');
    }
  }

  Future<UserCredential> signInWithGoogle() async {
    try {
      final googleSignIn = GoogleSignIn.instance;

      await googleSignIn.initialize(serverClientId: AppSecrets.serverClientId);

      final googleUser = await googleSignIn.authenticate();

      final googleAuth = googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
      );

      return await FirebaseAuth.instance.signInWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      throw AuthenticationException.fromFirebase(e);
    } catch (e) {
      throw AuthenticationException('Authentication failed.');
    }
  }

  Future<void> logout() async => await FirebaseAuth.instance.signOut();
}
