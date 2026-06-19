# Spotify2Youtube

Aplicativo Flutter completo para converter playlists do Spotify para o YouTube Music.

## Requisitos

- [Flutter SDK](https://docs.flutter.dev/get-started/install) instalado.
- Android Studio instalado para compilação e geração do APK.

## Como Configurar o Projeto

Como o projeto já contém todo o código fonte Dart (`lib/`) e o arquivo `pubspec.yaml`, siga estes passos para gerar a estrutura nativa (Android) e configurar as chaves:

1. Abra o terminal na pasta raiz do projeto (`c:/Users/Admin/Desktop/Teste/Spotify2Youtube`).
2. Execute o comando para recriar os arquivos de plataforma:
   ```bash
   flutter create .
   ```
3. Instale as dependências:
   ```bash
   flutter pub get
   ```

## Configuração do Spotify

1. Acesse o [Spotify Developer Dashboard](https://developer.spotify.com/dashboard/).
2. Crie um novo aplicativo.
3. Obtenha o seu **Client ID**.
4. Configure a **Redirect URI** no painel do Spotify como: `com.example.spotify2youtube://callback`
5. Abra o arquivo `lib/core/constants.dart` e substitua o valor de `spotifyClientId` pelo seu Client ID real.

## Configuração do Google / YouTube

1. Acesse o [Google Cloud Console](https://console.cloud.google.com/).
2. Crie um novo projeto e ative a **YouTube Data API v3**.
3. Configure a Tela de Consentimento OAuth (Adicione o seu email como usuário de teste se não for verificar o app).
4. Crie credenciais do tipo **ID do Cliente OAuth** para aplicativo Android.
   - Forneça o nome do pacote (ex: `com.example.spotify2youtube`).
   - Forneça o certificado SHA-1 do seu keystore de debug (ou produção).

## Configuração Específica do Android (Importante para o Login do Spotify)

Para que o login do Spotify funcione corretamente, você precisa configurar o esquema de redirecionamento no Android.

1. Abra o arquivo `android/app/build.gradle`.
2. Adicione a propriedade `manifestPlaceholders` na seção `defaultConfig`:

```gradle
android {
    defaultConfig {
        applicationId "com.example.spotify2youtube"
        // ...
        manifestPlaceholders = [
            'appAuthRedirectScheme': 'com.example.spotify2youtube'
        ]
    }
}
```

## Como Compilar e Gerar o APK

Você pode abrir o projeto diretamente no **Android Studio** ou usar a linha de comando:

### Via Android Studio
1. Abra o Android Studio.
2. Selecione `Open an existing Project` e escolha a pasta deste projeto.
3. No menu superior, vá em `Build` -> `Flutter` -> `Build APK`.

### Via Linha de Comando
No terminal, dentro da pasta do projeto, execute:
```bash
flutter build apk --release
```
O arquivo APK gerado estará disponível em `build/app/outputs/flutter-apk/app-release.apk`. Você pode transferi-lo para o seu dispositivo Android e instalar.
