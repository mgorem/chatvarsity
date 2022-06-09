///
/**
 * AuthProvider class handles google sign-n and sign-out methods
 * It also checks whether the user is logged in or not
 */
///
class AuthProvider extends ChangeNotifier {
  final GoogleSignIn googleSignIn;
  final FirebaseAuth firebaseAuth;
  final FirebaseFirestore firebaseFirestore;
  final SharedPreferences prefs;

  Status _status = Status.uninitialized;

  Status get status => _status;

  AuthProvider(
  {
    required this.googleSignIn,
    required this.firebaseAuth,
    required this.firebaseFirestore,
    required this.prefs
}
);

  String? getFirebaseUserId() {
    return prefs.getString(FireStoreConstants.id);
  }

  Future<bool> isloggedIn() async {
    bool isLoggedIn = await googleSignIn.isSignedIn()
        if (isLoggedIn &&
            prefs.getString(FireStoreConstants.id)?.isNotEmpty == true) {
          return true;
        } else {
          return false;
        }
      }
  }
  Future<bool> handleGoogleSignIn() async {
    _status = Status.authenticating;
    notifyListeners();

    GoogleSignInAccount? googleUser = await googleSignIn.signIn();
   if (googleUser != null) {
     GoogleSignInAuthentication? googleAuth = await googleUser.authentication;
     final AuthCredential credential = GoogleAuthProvider.credential(
       accessToken: googleAuth.accessToken,
       idToken: googleAuth.idToken,
     );

     User? firebaseUser =
         (await firebaseAuth.signInWithCredential(credential)).user;

     if (firebaseUser != null) {
       final QuerySnapshot result = await firebaseFirestore
           .collection(FirestoreConstants.pathUserCollection)
           .where(FirestoreConstants.id, isEqualTo: firebaseUser.uid)
           .get();
       final List<DocumentSnapshot> document = result.docs;
       if (document.isEmpty) {
         firebaseFirestore
             .collection(FirestoreConstants.pathUserCollection)
             .doc(firebaseUser.uid)
             .set({
           FirestoreConstants.displayName: firebaseUser.displayName,
           FirestoreConstants.photoUrl: firebaseUser.photoURL,
           FirestoreConstants.id: firebaseUser.uid,
           "createdAt: ": DateTime.now().millisecondsSinceEpoch.toString(),
           FirestoreConstants.chattingWith: null
         });}
  }
}