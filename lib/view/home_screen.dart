import 'package:flutter/material.dart';
import 'package:tuyensinh_ctu/app.dart';
import 'package:tuyensinh_ctu/model/data.dart';
import 'package:tuyensinh_ctu/view/loading_screen.dart';
import 'package:tuyensinh_ctu/view/post_widget.dart';
import 'package:tuyensinh_ctu/view/drawer_widget.dart';
import 'package:tuyensinh_ctu/view/detail_screen.dart';
import 'package:url_launcher/url_launcher.dart' as browser;

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String _url = App.home;
  BuildContext _scaffContext;
  int _backTapped = 0;

  @override
  Widget build(BuildContext context) {
    if (App.posts[_url] != null)
      return WillPopScope(
        onWillPop: _preventExit,
        child: _scaff,
      );
    else
      return WillPopScope(
          onWillPop: _preventExit,
          child: FutureBuilder(
            future: parse(_url),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return LoadingScreen(message: _url);
                default:
                  if (snapshot.hasError) {
                    print("Load error: ${snapshot.error.toString()}");
                    return LoadingScreen(
                      message:
                          'Không tìm thấy dữ liệu! Vui lòng kiểm tra kết nối mạng.',
                      allowReload: true,
                      allowGoHome: true,
                      reload: () {
                        _load(_url);
                      },
                      loadHome: () {
                        _load(App.home);
                      },
                    );
                  } else {
                    return _scaff;
                  }
              }
            },
          ));
  }

  void _load(String link) {
    if (!link.contains('#')) {
      link = correctLink(link);
      if (link.contains(App.home) &&
          !(link
              .substring(link.length - 4)
              .contains(new RegExp(r'[.]\w{3}', caseSensitive: false)))) {
        setState(() {
          _url = link;
        });
      } else {
        browser.launch(link, forceWebView: false);
      }
    }
  }

  void _launch(String link) {
    if (!link.contains('#')) {
      link = correctLink(link);
      if (link.contains(App.home) &&
          !(link
              .substring(link.length - 4)
              .contains(new RegExp(r'[.]\w{3}', caseSensitive: false)))) {
        Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => DetailScreen(url: link)));
      } else {
        browser.launch(link, forceWebView: false).catchError((e) {
          print("Error occurred: $e");
        });
      }
    }
  }

  Future<bool> _preventExit() async {
    _backTapped++;
    if (_backTapped == 1) {
      Scaffold.of(_scaffContext)
          .showSnackBar(new SnackBar(
            content: Text('Nhấp lần nữa để thoát!'),
            duration: Duration(seconds: 3),
            //  action: SnackBarAction(label: 'OK', onPressed: () {})
          ))
          .closed
          .then((reason) {
        _backTapped = 0;
      });

      return false;
    }
    _backTapped = 0;
    return true;
  }

  Scaffold get _scaff => new Scaffold(
        appBar: new AppBar(
          title: new Text(App.titles[_url]),
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
        body: Builder(builder: (BuildContext context) {
          _scaffContext = context;
          return ListView.builder(
            itemCount: App.posts[_url].length,
            itemBuilder: (BuildContext context, int i) {
              return Post(post: App.posts[_url][i], onTap: _launch);
            },
          );
        }),
      );
}
