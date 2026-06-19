class Track {
  final String id;
  final String name;
  final String artist;
  final String album;
  final int durationMs;

  Track({
    required this.id,
    required this.name,
    required this.artist,
    required this.album,
    required this.durationMs,
  });
}

class Playlist {
  final String id;
  final String name;
  final String? description;
  final int tracksCount;
  final String? imageUrl;
  bool isSelected;

  Playlist({
    required this.id,
    required this.name,
    this.description,
    required this.tracksCount,
    this.imageUrl,
    this.isSelected = false,
  });
}

class ConversionReport {
  final int totalTracks;
  final int convertedTracks;
  final int notFoundTracks;
  final List<String> notFoundList;

  ConversionReport({
    required this.totalTracks,
    required this.convertedTracks,
    required this.notFoundTracks,
    required this.notFoundList,
  });
}
