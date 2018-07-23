import 'package:flutter/material.dart';
import 'package:html/dom.dart' as dom;
import 'function.dart';
import 'drawer.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'data.dart';
import 'error.dart';
import 'content.dart';

/// Main screen
class Home extends StatefulWidget {
  String url;

  /// show the content of the url into the main screen
  Home({
    Key key,
    this.url,
  }) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: fetch(widget.url),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return _loading();
          case ConnectionState.none:
            pushNotification(context, snapshot.connectionState.toString());
            break;
          default:
            if (snapshot.hasError) {
              pushNotification(context, snapshot.error.toString());
            } else {
              //return _homepage(snapshot.data);
              return _testpage(snapshot.data);
            }
        }
      },
    );
  }

  /// Return loading screen
  Widget _loading() {
    return new Container(
        margin: EdgeInsets.all(0.0),
        color: Colors.white,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              new Image.asset(
                'assets/logo_dhct.png',
                height: 170.0,
                width: 170.0,
              ),
              new Container(
                margin: EdgeInsets.all(5.0),
                child: new LinearProgressIndicator(),
              )
            ]));
  }

  Widget _testpage(Information info) {
    return new Scaffold(
      appBar: new AppBar(title: new Text('Testing')),
      body: new ListView.builder(
        itemCount: info.img.length,
        itemBuilder: (BuildContext context, int index) {
          return new Card(
            child: new Container(
              margin: EdgeInsets.all(5.0),
              child: new ListTile(
                title: new Text('img'),
                subtitle: new Text(getLink(info.img[index])),
              )
            ),
          );
        },
      ),
    );
  }

}
