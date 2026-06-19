import 'package:flutter_appauth/flutter_appauth.dart';
import '../core/constants.dart';
import 'secure_storage_service.dart';

class SpotifyAuthService {
  final FlutterAppAuth _appAuth = const FlutterAppAuth();
  final SecureStorageService _storageService = SecureStorageService();

  static const String _accessTokenKey = 'spotify_access_token';
  static const String _refreshTokenKey = 'spotify_refresh_token';

  Future<bool> authenticate() async {
    try {
      final AuthorizationTokenResponse? result = await _appAuth.authorizeAndExchangeCode(
        AuthorizationTokenRequest(
          Constants.spotifyClientId,
          Constants.spotifyRedirectUrl,
          serviceConfiguration: const AuthorizationServiceConfiguration(
            authorizationEndpoint: Constants.spotifyAuthEndpoint,
            tokenEndpoint: Constants.spotifyTokenEndpoint,
          ),
          scopes: Constants.spotifyScopes,
        ),
      );

      if (result != null && result.accessToken != null) {
        await _storageService.saveToken(_accessTokenKey, result.accessToken!);
        if (result.refreshToken != null) {
          await _storageService.saveToken(_refreshTokenKey, result.refreshToken!);
        }
        return true;
      }
    } catch (e) {
      print('Spotify Auth Error: $e');
    }
    return false;
  }

  Future<String?> getValidAccessToken() async {
    // Simplification: returns token. For production, add expiry logic.
    return await _storageService.getToken(_accessTokenKey);
  }

  Future<void> logout() async {
    await _storageService.deleteToken(_accessTokenKey);
    await _storageService.deleteToken(_refreshTokenKey);
  }
}
