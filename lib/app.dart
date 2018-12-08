import 'package:flutter/material.dart';
import 'package:html/dom.dart' as dom;
import 'package:tuyensinh_ctu/view/message_widget.dart';
import 'package:tuyensinh_ctu/view/home_screen.dart';
import 'package:tuyensinh_ctu/view/chat_screen.dart';

class App extends StatefulWidget {
  static dom.Element menu;

  ///Posts of each links
  static Map<String, List<dom.Element>> posts = new Map();

  ///Titles of each links
  static Map<String, String> titles = new Map();

  static List<ChatMessage> messages = new List();

  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Thông tin tuyển sinh CTU',
      home: Home(),
      routes: {
        '/chat': (context) => new ChatScreen(),
      },
    );
  }
}
