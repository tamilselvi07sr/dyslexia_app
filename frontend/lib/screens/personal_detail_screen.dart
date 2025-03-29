import 'package:flutter/material.dart';

class PersonalDetailScreen extends StatelessWidget {
  const PersonalDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Personal Details")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(decoration: const InputDecoration(labelText: "Date of Birth")),
            TextField(decoration: const InputDecoration(labelText: "Gender")),
            TextField(decoration: const InputDecoration(labelText: "Country")),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/menu');  // Go to menu
              },
              child: const Text("Next"),
            ),
          ],
        ),
      ),
    );
  }
}
