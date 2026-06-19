import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';
import 'login_google_screen.dart';

class LoginSpotifyScreen extends StatelessWidget {
  const LoginSpotifyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Passo 1: Login Spotify')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.music_note, size: 100, color: Color(0xFF1DB954)),
            const SizedBox(height: 30),
            ElevatedButton.icon(
              icon: const Icon(Icons.login),
              label: const Text('Conectar com Spotify'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1DB954),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              ),
              onPressed: () async {
                await context.read<AppState>().loginSpotify();
                if (context.read<AppState>().isSpotifyAuthenticated && context.mounted) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const LoginGoogleScreen()),
                  );
                } else if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Falha ao autenticar no Spotify.')),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
