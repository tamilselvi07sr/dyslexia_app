import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:audioplayers/audioplayers.dart';

class TextAudioScreen extends StatefulWidget {
  const TextAudioScreen({super.key});

  @override
  _TextAudioScreenState createState() => _TextAudioScreenState();
}

class _TextAudioScreenState extends State<TextAudioScreen> {
  final TextEditingController _textController = TextEditingController();
  final AudioPlayer _audioPlayer = AudioPlayer();
  String? audioUrl;
  bool isLoading = false;

  Future<void> getSimplifiedAudio() async {
    setState(() {
      isLoading = true;
      audioUrl = null;
    });

    const String apiUrl = "https://dyslexia-app.onrender.com/simplify-audio";
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"text": _textController.text}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        audioUrl = data["audio_url"];
      });
    } else {
      setState(() {
        audioUrl = null;
      });
    }

    setState(() {
      isLoading = false;
    });
  }

  void _playAudio() async {
    if (audioUrl != null) {
      await _audioPlayer.play(UrlSource(audioUrl!));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Text as Audio")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
              controller: _textController,
              maxLines: 5,
              decoration: const InputDecoration(labelText: "Enter Text"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: getSimplifiedAudio,
              child: const Text("Generate Audio"),
            ),
            const SizedBox(height: 20),
            if (isLoading) const CircularProgressIndicator(),
            if (audioUrl != null)
              ElevatedButton(
                onPressed: _playAudio,
                child: const Text("Play Audio"),
              ),
          ],
        ),
      ),
    );
  }
}
