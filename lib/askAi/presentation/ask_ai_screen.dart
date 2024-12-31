import 'package:flutter/material.dart';

class AskAIPage extends StatelessWidget {
  const AskAIPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ask AI'),
        centerTitle: true,
      ),
      body: Center(
        child: Text(
          'Ask AI anything!',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}