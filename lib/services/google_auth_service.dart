import 'package:google_sign_in/google_sign_in.dart';
import '../core/constants.dart';

class GoogleAuthService {
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: Constants.googleScopes,
  );

  Future<GoogleSignInAccount?> signIn() async {
    try {
      return await _googleSignIn.signIn();
    } catch (error) {
      print('Error during Google Sign In: $error');
      return null;
    }
  }

  Future<GoogleSignInAccount?> signInSilently() async {
    return await _googleSignIn.signInSilently();
  }

  Future<void> signOut() async {
    await _googleSignIn.disconnect();
  }
  
  Future<Map<String, String>?> getAuthHeaders() async {
    final account = _googleSignIn.currentUser;
    if (account == null) return null;
    return await account.authHeaders;
  }
}
