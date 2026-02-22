import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:habits_app/domain/entities/user_entity.dart';
import 'package:habits_app/domain/repositories/auth/i_auth_repository.dart';

/// Firebase implementation of [IAuthRepository].
/// Google Sign-In is an implementation detail (DIP: depend on IAuthenticator).
class FirebaseAuthRepository implements IAuthRepository {
  FirebaseAuthRepository({
    FirebaseAuth? auth,
    GoogleSignIn? googleSignIn,
  })  : _auth = auth ?? FirebaseAuth.instance,
        _googleSignIn = googleSignIn ?? GoogleSignIn();

  final FirebaseAuth _auth;
  final GoogleSignIn _googleSignIn;

  @override
  Future<void> init() async {
    // No-op: Firebase Auth is ready after Firebase.initializeApp()
  }

  UserEntity? _userFromFirebaseUser(User? user) {
    if (user == null) return null;
    return UserEntity(
      id: user.uid,
      email: user.email ?? '',
      name: user.displayName ?? user.email ?? '',
      password: '', 
    );
  }

  @override
  Future<UserEntity?> login(String email, String password) async {
    try {
      final cred = await _auth.signInWithEmailAndPassword(email: email, password: password);
      return _userFromFirebaseUser(cred.user);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'wrong-password' ||
          e.code == 'user-not-found' ||
          e.code == 'invalid-credential' ||
          e.code == 'invalid-email') {
        return null;
      }
      rethrow;
    }
  }

  @override
  Future<UserEntity?> signInWithGoogle() async {
    final googleUser = await _googleSignIn.signIn();
    if (googleUser == null) return null;
    final googleAuth = await googleUser.authentication;
    final cred = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    final userCred = await _auth.signInWithCredential(cred);
    return _userFromFirebaseUser(userCred.user);
  }

  @override
  Future<void> logout() async {
    // Best-effort: sign out from Google first (so next time account picker shows).
    try {
      await _googleSignIn.signOut();
    } catch (_) {
      // Ignore channel/plugin errors; Firebase sign-out below is what matters.
    }
    await _auth.signOut();
  }

  @override
  Future<UserEntity?> getCurrentUser() async {
    return _userFromFirebaseUser(_auth.currentUser);
  }

  @override
  Future<bool> register(String name, String email, String password) async {
    try {
      final cred = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      if (cred.user != null) {
        await cred.user!.updateDisplayName(name);
        return true;
      }
      return false;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') return false;
      rethrow;
    }
  }

  @override
  Future<void> updateUser(UserEntity user) async {
    final u = _auth.currentUser;
    if (u == null || u.uid != user.id) return;
    if (user.name.isNotEmpty) await u.updateDisplayName(user.name);
  }

  @override
  Future<void> deleteUser(String userId) async {
    final u = _auth.currentUser;
    if (u != null && u.uid == userId) await u.delete();
  }
}
