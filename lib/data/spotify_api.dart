import 'dart:convert';
import 'package:http/http.dart' as http;
import '../domain/models.dart';

class SpotifyApi {
  final String _baseUrl = 'https://api.spotify.com/v1';

  Future<List<Playlist>> getUserPlaylists(String accessToken) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/me/playlists?limit=50'),
      headers: {'Authorization': 'Bearer $accessToken'},
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final items = data['items'] as List;
      return items.map((item) {
        return Playlist(
          id: item['id'],
          name: item['name'],
          description: item['description'],
          tracksCount: item['tracks']['total'],
          imageUrl: (item['images'] != null && item['images'].isNotEmpty) 
              ? item['images'][0]['url'] 
              : null,
        );
      }).toList();
    } else {
      throw Exception('Failed to load playlists: ${response.body}');
    }
  }

  Future<List<Track>> getPlaylistTracks(String accessToken, String playlistId) async {
    List<Track> tracks = [];
    String? nextUrl = '$_baseUrl/playlists/$playlistId/tracks';

    while (nextUrl != null) {
      final response = await http.get(
        Uri.parse(nextUrl),
        headers: {'Authorization': 'Bearer $accessToken'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final items = data['items'] as List;
        
        for (var item in items) {
          final trackNode = item['track'];
          if (trackNode == null) continue;
          
          final artists = trackNode['artists'] as List;
          final artistName = artists.isNotEmpty ? artists[0]['name'] : 'Unknown Artist';
          
          tracks.add(Track(
            id: trackNode['id'] ?? '',
            name: trackNode['name'] ?? 'Unknown Track',
            artist: artistName,
            album: trackNode['album']?['name'] ?? 'Unknown Album',
            durationMs: trackNode['duration_ms'] ?? 0,
          ));
        }
        
        nextUrl = data['next'];
      } else {
        throw Exception('Failed to load tracks: ${response.body}');
      }
    }
    
    return tracks;
  }
}
