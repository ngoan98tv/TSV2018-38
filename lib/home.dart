import 'package:flutter/material.dart';
import 'chat.dart';
import 'drawer.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: new Text("Trang chủ"),
        actions: <Widget>[
          new IconButton(
            icon: new Icon(Icons.chat),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Conversation())
              );
            },
          ),
        ],
      ),
      body: new Column(),
      drawer: mainDrawer(),
    );
  }
}
