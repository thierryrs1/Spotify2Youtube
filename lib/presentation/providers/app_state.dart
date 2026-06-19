import 'package:flutter/foundation.dart';
import '../services/spotify_auth_service.dart';
import '../services/google_auth_service.dart';
import '../data/spotify_api.dart';
import '../data/youtube_api.dart';
import '../domain/models.dart';

class AppState extends ChangeNotifier {
  final SpotifyAuthService _spotifyAuth = SpotifyAuthService();
  final GoogleAuthService _googleAuth = GoogleAuthService();
  final SpotifyApi _spotifyApi = SpotifyApi();
  final YoutubeApi _youtubeApi = YoutubeApi();

  bool isSpotifyAuthenticated = false;
  bool isGoogleAuthenticated = false;

  List<Playlist> spotifyPlaylists = [];
  bool isLoadingPlaylists = false;

  int totalTracksToConvert = 0;
  int currentConvertedTracks = 0;
  String currentStatus = '';
  
  ConversionReport? lastReport;

  Future<void> loginSpotify() async {
    isSpotifyAuthenticated = await _spotifyAuth.authenticate();
    notifyListeners();
  }

  Future<void> loginGoogle() async {
    final account = await _googleAuth.signIn();
    isGoogleAuthenticated = account != null;
    notifyListeners();
  }

  Future<void> fetchSpotifyPlaylists() async {
    isLoadingPlaylists = true;
    notifyListeners();

    try {
      final token = await _spotifyAuth.getValidAccessToken();
      if (token != null) {
        spotifyPlaylists = await _spotifyApi.getUserPlaylists(token);
      }
    } catch (e) {
      print('Error fetching playlists: $e');
    }

    isLoadingPlaylists = false;
    notifyListeners();
  }

  void togglePlaylistSelection(String id) {
    final idx = spotifyPlaylists.indexWhere((p) => p.id == id);
    if (idx != -1) {
      spotifyPlaylists[idx].isSelected = !spotifyPlaylists[idx].isSelected;
      notifyListeners();
    }
  }

  Future<void> convertSelectedPlaylists() async {
    final selectedPlaylists = spotifyPlaylists.where((p) => p.isSelected).toList();
    if (selectedPlaylists.isEmpty) return;

    final googleHeaders = await _googleAuth.getAuthHeaders();
    if (googleHeaders == null) return;

    final spotifyToken = await _spotifyAuth.getValidAccessToken();
    if (spotifyToken == null) return;

    int totalConverted = 0;
    int totalNotFound = 0;
    List<String> notFoundList = [];

    totalTracksToConvert = selectedPlaylists.fold(0, (sum, p) => sum + p.tracksCount);
    currentConvertedTracks = 0;
    currentStatus = 'Iniciando conversão...';
    notifyListeners();

    for (var playlist in selectedPlaylists) {
      currentStatus = 'Lendo playlist: ${playlist.name}';
      notifyListeners();

      try {
        final tracks = await _spotifyApi.getPlaylistTracks(spotifyToken, playlist.id);
        
        currentStatus = 'Criando playlist no YouTube: ${playlist.name}';
        notifyListeners();

        final ytPlaylistId = await _youtubeApi.createPlaylist(
          googleHeaders, 
          playlist.name, 
          playlist.description
        );

        if (ytPlaylistId != null) {
          for (var track in tracks) {
            currentStatus = 'Pesquisando: ${track.name} - ${track.artist}';
            notifyListeners();

            final videoId = await _youtubeApi.searchTrack(googleHeaders, track);
            if (videoId != null) {
              await _youtubeApi.addTrackToPlaylist(googleHeaders, ytPlaylistId, videoId);
              totalConverted++;
            } else {
              totalNotFound++;
              notFoundList.add('${track.name} - ${track.artist}');
            }
            
            currentConvertedTracks++;
            notifyListeners();
            // Delay to avoid quota/rate limit issues
            await Future.delayed(const Duration(milliseconds: 500));
          }
        }
      } catch (e) {
        print('Error converting playlist: $e');
      }
    }

    lastReport = ConversionReport(
      totalTracks: totalTracksToConvert,
      convertedTracks: totalConverted,
      notFoundTracks: totalNotFound,
      notFoundList: notFoundList,
    );
    
    currentStatus = 'Conversão concluída!';
    notifyListeners();
  }
}
