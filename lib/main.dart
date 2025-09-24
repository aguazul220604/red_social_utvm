import 'package:flutter/material.dart';
import 'package:red_social_utvm/screens/feed_screen.dart';
import 'package:red_social_utvm/service/api_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final api = ApiService();

    return MaterialApp(
      title: 'Mini Red Social',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: FeedScreen(api: api),
    );
  }
}
