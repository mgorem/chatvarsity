// Consists of how user details will be required
/*Consists of two functions with map and factory method
  to read data from the snapshot that Firebase Firestore
  returns
*/ 
class chatUser extends Equatable {
  final String id;
  final String photoUrl;
  final String displayName;
  final String phoneNumber;
  final String aboutMe;

  const chatUser(
  {required this.id,
   required this.photoUrl,
   required this.displayName,
   required this.phoneNumber,
   required this.aboutMe});
}