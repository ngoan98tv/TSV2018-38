import 'package:flutter/material.dart';

class Conversation extends StatefulWidget {
  @override
  _ConversationState createState() => _ConversationState();
}

class _ConversationState extends State<Conversation> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: new Text("Tư vấn"),
        actions: <Widget>[
          new IconButton(
            icon: new Icon(Icons.info),
            onPressed: () {},
          ),
        ],
      ),
      body: new Column(),
    );
  }
}
