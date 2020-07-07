import 'package:math_app/models/member.dart';
import 'package:math_app/services/database_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final _auth = FirebaseAuth.instance;

  Member _userFromFirebase(FirebaseUser user) {
    return user != null
        ? Member(uid: user.uid)
        : null; // convert firebase user to [Member] class
  }

// Check the state of a member
  Stream<Member> get onAuthStateChange {
    try {
      return _auth.onAuthStateChanged.map(_userFromFirebase);
    } catch (e) {
      print("ERROR MESSAGE $e");
      return null;
    }
  }

 Future<Member> signInWithEmail({String email, String password}) async {
    try {
      final authResult = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return _userFromFirebase(authResult.user);
    } catch (e) {
      print("ERROR MESSAGE $e");
      return null;
    }
  }

  Future<Member> createMember({String email, String password, String username, bool challenge}) async {
    try {
      final authResult = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);

      await DatabaseService(uid: authResult.user.uid).updateMemberData(
          username: username??"",
          email: email??"",
          challenge: challenge??false,
        );

      return _userFromFirebase(authResult.user);
    } catch (e) {
      print("ERROR MESSAGE $e");
      return null;
    }
  }

  Future<void> signOut() async {
    try {
      print("User is signed out die man");
      return await _auth.signOut();
    } catch (e) {
      print("ERROR MESSAGE $e");
      return null;
    }
  }
}
