import 'package:flutter/material.dart';
import 'package:html/dom.dart' as dom;
import 'package:url_launcher/url_launcher.dart' as browser;
import 'dart:async';
import 'loader.dart';
import 'presenter.dart';
import 'chat.dart';

const homeLink = 'https://tuyensinh.ctu.edu.vn';

class App extends StatefulWidget {
  ///Access token of DialogFlow for Chat feature.
  static var dialogflowToken = "bc39b266289d41129ebf72200338eb10";

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

  ///Get link from a DOM object
  static String getLink(dom.Element element) {
    String tmp;
    element.attributes.forEach((k, v) {
      if (k.toString() == 'src' || k.toString() == 'href') {
        tmp = v.toString();
      }
    });
    return tmp;
  }

  ///Launch to an URL
  static void launch(BuildContext context, String url) async {
    if (!url.contains('#')) {
      if (url == '/')
        Navigator.popUntil(context, ModalRoute.withName('/'));
      else {
        url = correctLink(url);
        if (url.contains('tuyensinh.ctu.edu.vn') &&
            url.substring(url.length - 3) != 'pdf' &&
            url.substring(url.length - 3) != 'jpg') {
          await Loader.fetch(context, url);
          Navigator.pop(context);
          Navigator.of(context).push(new MaterialPageRoute(
              builder: (BuildContext context) => Presenter(url)));
        } else if (await browser.canLaunch(url)) {
          await browser.launch(url, forceWebView: false);
        } else {
          pushNotification(context, 'Could not launch $url', '');
        }
      }
    }
  }

  ///Correct a link to http standard
  static String correctLink(String url) {
    if (url.length > 4 && url.substring(0, 4) != 'http') return homeLink + url;
    return url;
  }

  ///Notify an error
  static Future<Null> pushNotification(
      BuildContext context, String error, String message) async {
    return showDialog<Null>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return new AlertDialog(
          title: new Text("What's happening!"),
          content: new SingleChildScrollView(
            child: new ListBody(
              children: <Widget>[
                new Text(
                  error,
                  style: new TextStyle(color: Colors.redAccent),
                ),
                new Text('Message: $message',
                    style: new TextStyle(color: Colors.red)),
              ],
            ),
          ),
          actions: <Widget>[
            new RaisedButton(
              child: new Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  ///Show waiting screen while loading
  static Widget waitingScreen(String text) {
    return new Container(
        margin: EdgeInsets.all(0.0),
        color: Colors.white,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              new Image.asset(
                'assets/logo_dhct.png',
                height: 170.0,
                width: 170.0,
              ),
              new Container(
                margin: EdgeInsets.all(16.0),
                child: Text(text,
                    style: TextStyle(
                        fontSize: 10.0,
                        fontWeight: FontWeight.w100,
                        decoration: TextDecoration.none,
                        color: Colors.blueGrey)),
              ),
              new Container(
                margin: EdgeInsets.all(16.0),
                child: new LinearProgressIndicator(),
              )
            ]));
  }
}

class _AppState extends State<App> {
  String link;
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Thông tin tuyển sinh CTU',
      initialRoute: '/load',
      routes: {
        '/': (context) => new Presenter(homeLink),
        '/chat': (context) => new Conversation(),
        '/load': (context) => new Loader(url: homeLink,),
      },
    );
  }
}
