import 'package:flutter/material.dart';
import 'package:tuyensinh/drawer.dart';
import 'app.dart';

class Presenter extends StatefulWidget {
  String url = 'https://tuyensinh.ctu.edu.vn';
  String title = 'Đại học Cần Thơ';

  Presenter(this.url);

  @override
  _PresenterState createState() => _PresenterState();
}

class _PresenterState extends State<Presenter> {
  @override
  Widget build(BuildContext context) {
    if (App.titles[widget.url] != null) widget.title = App.titles[widget.url];
    final appbar = new AppBar(
      title: new Text(widget.title),
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
      drawer: mainDrawer(context, App.mainMenu),
      body: ListView(children: App.postData[widget.url]),
    );
  }
}
