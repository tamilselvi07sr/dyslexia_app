import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ReadTextScreen extends StatefulWidget {
  const ReadTextScreen({super.key});

  @override
  _ReadTextScreenState createState() => _ReadTextScreenState();
}

class _ReadTextScreenState extends State<ReadTextScreen> {
  final TextEditingController textController = TextEditingController();
  String? simplifiedText;
  bool isLoading = false;

  Future<void> getSimplifiedText() async {
    setState(() {
      isLoading = true;
      simplifiedText = null;
    });

    const String apiUrl = "https://dyslexia-app.onrender.com/simplify";
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"text": textController.text}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        simplifiedText = data["simplified_text"];
      });
    } else {
      setState(() {
        simplifiedText = "Error: Could not simplify text.";
      });
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Read Text")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
              controller: textController,
              maxLines: 5,
              decoration: const InputDecoration(labelText: "Enter Text"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: getSimplifiedText,
              child: const Text("Generate Simplified Text"),
            ),
            const SizedBox(height: 20),
            if (isLoading) const CircularProgressIndicator(),
            if (simplifiedText != null)
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.blue[100],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  simplifiedText!,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
