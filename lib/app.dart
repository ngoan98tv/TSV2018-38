import 'package:flutter/material.dart';
import 'presenter.dart';
import 'chat.dart';

class App extends StatefulWidget {
  static final link = "https://tuyensinh.ctu.edu.vn";

  ///Access token of DialogFlow for Chat feature.
  static final dialogflowToken = "bc39b266289d41129ebf72200338eb10";

  ///Content of main menu.
  static Widget mainMenu;

  ///List of blocks content consist of notification block.
  static List blockData;

  ///Data of links, format as <String link, List posts>
  static var postData = new Map();

  ///Titles of links
  static var titles = new Map();

  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Thông tin tuyển sinh CTU',
      routes: {
        '/': (context) => new Presenter(url: App.link),
        '/chat': (context) => new Conversation(),
      },
    );
  }
}
