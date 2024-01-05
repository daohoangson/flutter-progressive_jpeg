import 'package:flutter/material.dart';

import 'image/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Progressive JPEG PoC',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final controller = TextEditingController(
    // https://unsplash.com/photos/a-hummingbird-flying-in-the-air-with-a-blurry-background-snjPkR2I3j0
    text:
        'https://plus.unsplash.com/premium_photo-1669279284406-3ed73d52ae50?q=80&w=2048&auto=format&fit=crop',
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: AnimatedBuilder(
              animation: controller,
              builder: (context, _) {
                return Image(
                  image: MyImageProvider(controller.text),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: controller,
            ),
          ),
        ],
      ),
    );
  }
}
