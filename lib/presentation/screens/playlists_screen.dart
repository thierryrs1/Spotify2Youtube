import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';
import 'conversion_screen.dart';

class PlaylistsScreen extends StatefulWidget {
  const PlaylistsScreen({super.key});

  @override
  State<PlaylistsScreen> createState() => _PlaylistsScreenState();
}

class _PlaylistsScreenState extends State<PlaylistsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AppState>().fetchSpotifyPlaylists();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();

    return Scaffold(
      appBar: AppBar(title: const Text('Suas Playlists do Spotify')),
      body: state.isLoadingPlaylists
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: state.spotifyPlaylists.length,
              itemBuilder: (context, index) {
                final playlist = state.spotifyPlaylists[index];
                return ListTile(
                  leading: playlist.imageUrl != null
                      ? Image.network(playlist.imageUrl!, width: 50, height: 50, fit: BoxFit.cover)
                      : const Icon(Icons.music_video, size: 50),
                  title: Text(playlist.name),
                  subtitle: Text('${playlist.tracksCount} músicas'),
                  trailing: Checkbox(
                    value: playlist.isSelected,
                    onChanged: (val) {
                      context.read<AppState>().togglePlaylistSelection(playlist.id);
                    },
                  ),
                  onTap: () {
                    context.read<AppState>().togglePlaylistSelection(playlist.id);
                  },
                );
              },
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: state.spotifyPlaylists.any((p) => p.isSelected)
            ? () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ConversionScreen()),
                );
              }
            : null,
        label: const Text('Converter Selecionadas'),
        icon: const Icon(Icons.sync),
      ),
    );
  }
}
