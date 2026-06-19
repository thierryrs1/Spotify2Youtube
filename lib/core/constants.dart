class Constants {
  // Spotify OAuth
  // ATENÇÃO: Substitua pelo Client ID do seu aplicativo no painel do Spotify Developer
  static const String spotifyClientId = '7c090a191c4e43c59e97c0da896f0777'; 
  static const String spotifyRedirectUrl = 'spotify2youtube://callback'; 
  
  static const String spotifyAuthEndpoint = 'https://accounts.spotify.com/authorize';
  static const String spotifyTokenEndpoint = 'https://accounts.spotify.com/api/token';
  
  static const List<String> spotifyScopes = [
    'user-read-private',
    'user-read-email',
    'playlist-read-private',
    'playlist-read-collaborative',
  ];

  // Google / YouTube OAuth
  static const List<String> googleScopes = [
    'email',
    'https://www.googleapis.com/auth/youtube',
  ];
}
