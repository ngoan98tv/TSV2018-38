import 'package:flutter/material.dart';
import 'package:tuyensinh/app.dart';
import 'package:tuyensinh/model/data.dart';
import 'package:tuyensinh/view/loading_screen.dart';
import 'package:tuyensinh/view/post_widget.dart';
import 'package:tuyensinh/view/drawer_widget.dart';
import 'package:url_launcher/url_launcher.dart' as browser;

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String url = App.home;

  @override
  Widget build(BuildContext context) {
    if (App.posts[url] != null)
      return scaff;
    else
      return FutureBuilder(
        future: parse(url),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return LoadingScreen(message: url);
            default:
              if (snapshot.hasError) {
                print("Load error: ${snapshot.error.toString()}");
                return LoadingScreen(message: 'Không tìm thấy dữ liệu!');
              } else {
                return scaff;
              }
          }
        },
      );
  }

  void _load(String link) {
    if (!link.contains('#')) {
      link = correctLink(link);
      if (link.contains('tuyensinh.ctu.edu.vn') &&
          link.substring(link.length - 3) != 'pdf' &&
          link.substring(link.length - 3) != 'jpg') {
        setState(() {
          url = link;
        });
      } else {
        browser.launch(link, forceWebView: false);
      }
    }
  }

  Scaffold get scaff => new Scaffold(
        appBar: new AppBar(
          title: new Text(App.titles[url]),
          actions: <Widget>[
            new IconButton(
              icon: new Icon(Icons.chat),
              onPressed: () {
                Navigator.pushNamed(context, '/chat');
              },
            ),
          ],
        ),
        drawer: DrawerMenu(
          content: App.menu,
          onTap: (link) {
            _load(link);
            Navigator.pop(context);
          },
        ),
        body: ListView.builder(
          itemCount: App.posts[url].length,
          itemBuilder: (BuildContext context, int i) {
            return Post(post: App.posts[url][i], onTap: _load);
          },
        ),
      );
}
