import 'package:googleapis/youtube/v3.dart' as yt;
import 'package:http/http.dart' as http;
import '../domain/models.dart' as domain;

class AuthClient extends http.BaseClient {
  final Map<String, String> headers;
  final http.Client _client = http.Client();

  AuthClient(this.headers);

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    request.headers.addAll(headers);
    return _client.send(request);
  }
}

class YoutubeApi {
  Future<String?> searchTrack(Map<String, String> authHeaders, domain.Track track) async {
    final client = AuthClient(authHeaders);
    final youtube = yt.YouTubeApi(client);

    final query = '${track.name} ${track.artist}';
    try {
      final searchListResponse = await youtube.search.list(
        ['snippet'],
        q: query,
        type: ['video'],
        maxResults: 5,
        videoCategoryId: '10', // Music category
      );

      if (searchListResponse.items == null || searchListResponse.items!.isEmpty) {
        return null;
      }
      
      for (var item in searchListResponse.items!) {
        final title = item.snippet?.title?.toLowerCase() ?? '';
        final channelTitle = item.snippet?.channelTitle?.toLowerCase() ?? '';
        
        bool isOfficial = title.contains('official') || channelTitle.contains('vevo') || channelTitle.contains('official');
        if (isOfficial) {
          return item.id?.videoId;
        }
      }
      return searchListResponse.items!.first.id?.videoId;
    } catch (e) {
      print('YouTube Search Error: $e');
      return null;
    }
  }

  Future<String?> createPlaylist(Map<String, String> authHeaders, String title, String? description) async {
    final client = AuthClient(authHeaders);
    final youtube = yt.YouTubeApi(client);

    final playlist = yt.Playlist(
      snippet: yt.PlaylistSnippet(
        title: title,
        description: description ?? 'Created by Spotify2Youtube App',
      ),
      status: yt.PlaylistStatus(privacyStatus: 'private'),
    );

    try {
      final response = await youtube.playlists.insert(playlist, ['snippet', 'status']);
      return response.id;
    } catch (e) {
      print('YouTube Create Playlist Error: $e');
      return null;
    }
  }

  Future<bool> addTrackToPlaylist(Map<String, String> authHeaders, String playlistId, String videoId) async {
    final client = AuthClient(authHeaders);
    final youtube = yt.YouTubeApi(client);

    final playlistItem = yt.PlaylistItem(
      snippet: yt.PlaylistItemSnippet(
        playlistId: playlistId,
        resourceId: yt.ResourceId(
          kind: 'youtube#video',
          videoId: videoId,
        ),
      ),
    );

    try {
      await youtube.playlistItems.insert(playlistItem, ['snippet']);
      return true;
    } catch (e) {
      print('YouTube Add Track Error: $e');
      return false;
    }
  }
}
