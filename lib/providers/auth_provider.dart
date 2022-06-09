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
}