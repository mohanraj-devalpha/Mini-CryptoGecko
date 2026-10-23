import 'package:flutter/material.dart';

class CoinsScreen extends StatelessWidget {
  const CoinsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Coins')),
      body: const Center(child: Text('Coins Screen')),
    );
  }
}
