import 'package:flutter/material.dart';
import 'package:tuyensinh/content.dart';
import 'package:tuyensinh/drawer.dart';
import 'data.dart';

class MainView extends StatefulWidget {
  final Information info;

  MainView({Key key, @required this.info}) : super(key: key);

  @override
  _MainViewState createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  @override
  Widget build(BuildContext context) {
    final appbar = new AppBar(
      title: new Text(widget.info.title),
      actions: <Widget>[
        new IconButton(
          icon: new Icon(Icons.chat),
          onPressed: () {
            Navigator.pushNamed(context, '/chat');
          },
        ),
      ],
    );

    return Scaffold(
      appBar: appbar,
      drawer: mainDrawer(context, widget.info.art_hmenu),
      body: new ListView(
        children: postContent(
            context, widget.info.art_postheader, widget.info.art_postcontent),
      ),
    );
  }
}
