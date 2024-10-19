import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(
    home: HomePage(),
  ));
}

class Music {
  final String name;
  final String artist;
  final String album;
  final String image;
  final String link;

  Music(this.name, this.artist, this.album, this.image, this.link);
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    List<Music> musics = [
      Music(
          'A Little piece of Heaven',
          'Avenged Sevenfold',
          'Nightmare',
          'https://i.scdn.co/image/ab67616d0000b27333c52ca8309741c6999ca742',
          'https://p.scdn.co/mp3-preview/e72044e3fe169a4029ef811ad911debc1215399b'),
      Music(
          'Brass',
          'Dirty Rush & Gregor Es',
          '',
          'https://i.scdn.co/image/ab67616d0000b273647e4b3f8949416e20bf7b98',
          'https://p.scdn.co/mp3-preview/bf3ed07f87c7b1ce54f66d9e9c39363c89372526'),
      Music(
          'Perdoname',
          'Deorro, DyCy, Adrian Delgado',
          'Perdoname',
          'https://i.scdn.co/image/ab67616d0000b273a859ec0e8aa49edeaafab89c',
          'https://p.scdn.co/mp3-preview/25361e9593c8374d2565bc0a53ecd14f8aa68931'),
      Music(
          'I\'m an Albatraoz',
          'AronChupa, Little Sis Nora',
          '',
          'https://i.scdn.co/image/ab67616d0000b2734676cbf99a56d53dc494abfb',
          'https://p.scdn.co/mp3-preview/8ffd93badd95d84879e88e06da4c084edff2032b'),
      Music(
          'Blank Space',
          'I Prevail',
          '',
          'https://i.scdn.co/image/ab67616d0000b2737294c3d8698783718955a286',
          'https://p.scdn.co/mp3-preview/a5805e4bc7fba164e84736d047afaf7e052670c6'),
    ];

    List<Music> filteredMusics = musics;

    return MaterialApp(
      title: "Music Palyer",
      home: Scaffold(
        appBar: AppBar(
          title:
              const Text('Music Palyer', style: TextStyle(color: Colors.white)),
          backgroundColor: Colors.black,
        ),
        body: ListOfMusic(filteredMusics),
      ),
    );
  }
}

class ListOfMusic extends StatelessWidget {
  const ListOfMusic(this.musics, {super.key});

  final List<Music> musics;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        for (var music in musics)
          ListTile(
            leading: const Icon(Icons.album),
            title: Text(music.name),
            subtitle: Text(music.artist),
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MusicDetails(music),
                )),
          ),
      ],
    );
  }
}

class MusicDetails extends StatefulWidget {
  const MusicDetails(this.music, {super.key});

  final Music music;

  @override
  State<MusicDetails> createState() => _MusicDetailsState();
}

class _MusicDetailsState extends State<MusicDetails> {
  Music get music => widget.music;
  AudioPlayer audioPlayer = AudioPlayer();
  bool isPlaying = false;
  double progress = 0;

  @override
  Widget build(BuildContext context) {
    audioPlayer.onPositionChanged.listen((Duration duration) {
      setState(() {
        progress = duration.inSeconds.toDouble() / 30;
      });
    });

    audioPlayer.onPlayerStateChanged.listen((event) {
      setState(() {
        if (PlayerState.completed == event) {
          isPlaying = false;
          progress = 0;
        } else if (PlayerState.paused == event) {
          isPlaying = false;
        } else if (PlayerState.stopped == event) {
          isPlaying = false;
        } else if (PlayerState.playing == event) {
          isPlaying = true;
        }
      });
    });

    void playMusic(String url) async {
      if (progress > 0) {
        await audioPlayer.resume();
      } else {
        await audioPlayer.play(UrlSource(url));
      }
    }

    void pauseMusic() async {
      await audioPlayer.pause();
    }

    return MaterialApp(
      title: music.name,
      home: Scaffold(
        appBar: AppBar(
          title: Text(music.name, style: const TextStyle(color: Colors.white)),
          backgroundColor: Colors.black,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
              pauseMusic();
            },
            icon: const Icon(Icons.arrow_back, color: Colors.white),
          ),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.network(music.image, width: 300, height: 300),
            Text(music.name,
                style: const TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                )),
            Text(
              music.artist,
              style: const TextStyle(
                fontSize: 20,
                color: Colors.grey,
              ),
            ),
            Text(
              music.album,
              style: const TextStyle(
                fontSize: 15,
                color: Colors.grey,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  color: Colors.black,
                  onPressed: () {
                    if (isPlaying) {
                      pauseMusic();
                    } else {
                      playMusic(music.link);
                    }
                  },
                  icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow),
                ),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        '0:${(progress * 30).toInt().toString().padLeft(2, '0')}',
                        style: const TextStyle(
                          fontSize: 15,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 200,
                      child: LinearProgressIndicator(
                        value: progress,
                        valueColor:
                            const AlwaysStoppedAnimation<Color>(Colors.black),
                        backgroundColor: Colors.grey,
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        '0:30',
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
