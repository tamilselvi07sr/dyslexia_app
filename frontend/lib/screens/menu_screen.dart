import 'package:flutter/material.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Menu")),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ListTile(
            title: const Text("Read Text"),
            onTap: () {
              Navigator.pushNamed(context, '/read_text');
            },
          ),
          ListTile(
            title: const Text("Text As Audio"),
            onTap: () {
              Navigator.pushNamed(context, '/text_audio');
            },
          ),
          ListTile(
            title: const Text("Settings"),
            onTap: () {
              Navigator.pushNamed(context, '/settings');
            },
          ),
        ],
      ),
    );
  }
}
