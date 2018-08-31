import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart' as browser;
import 'package:html/dom.dart' as dom;
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:html2md/html2md.dart' as html2md;
import 'package:url_launcher/url_launcher.dart' as laucher;
import 'package:html/parser.dart' as parser;
import 'app.dart';

class Presenter extends StatefulWidget {
  String url;

  Presenter({Key key, @required this.url});

  @override
  _PresenterState createState() => _PresenterState();
}

class _PresenterState extends State<Presenter> {
  @override
  Widget build(BuildContext context) {
    if (App.postData[widget.url] != null)
      return new Scaffold(
        appBar: new AppBar(
          title: new Text(App.titles[widget.url]),
          actions: <Widget>[
            new IconButton(
              icon: new Icon(Icons.chat),
              onPressed: () {
                Navigator.pushNamed(context, '/chat');
              },
            ),
          ],
        ),
        drawer: drawer(context, App.mainMenu),
        body: ListView(children: App.postData[widget.url]),
      );
    else
      return FutureBuilder(
        future: parse(context, widget.url),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return loadingScreen(widget.url);
            default:
              if (snapshot.hasError) {
                return loadingScreen('Không có kết nối Internet');
              } else {
                return new Scaffold(
                  appBar: new AppBar(
                    title: new Text(App.titles[widget.url]),
                    actions: <Widget>[
                      new IconButton(
                        icon: new Icon(Icons.chat),
                        onPressed: () {
                          Navigator.pushNamed(context, '/chat');
                        },
                      ),
                    ],
                  ),
                  drawer: drawer(context, App.mainMenu),
                  body: ListView(children: App.postData[widget.url]),
                );
              }
          }
        },
      );
  }

  ///Get HTML Document from the URL
  Future<String> fetch(String url) async {
    var response = await http.get(url);

    return response.body;
  }

  ///Show loading screen while loading
  Widget loadingScreen(String text) {
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

  ///Get link from a DOM object
  String getLink(dom.Element element) {
    String tmp;
    element.attributes.forEach((k, v) {
      if (k.toString() == 'src' || k.toString() == 'href') {
        tmp = v.toString();
      }
    });
    return tmp;
  }

  ///Correct a link to http standard
  String correctLink(String url) {
    if (url.length > 4 && url.substring(0, 4) != 'http') return App.link + url;
    return url;
  }

  ///Notify an error
  Future<Null> pushNotification(
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

  ///return drawer menu
  Widget drawer(BuildContext context, Widget content) {
    return new Drawer(
        child: new ListView(
      children: <Widget>[
        new DrawerHeader(
          child: new Image.asset('assets/logo_dhct.png'),
        ),
        content,
      ],
    ));
  }

  ///Show waiting notification
  Widget waitingScreen() {
    return new Opacity(
        opacity: 0.7,
        child: new AlertDialog(
          title: new Text('Đang tải...'),
          content: LinearProgressIndicator(),
        ));
  }

  ///Launch to an URL
  void launch(BuildContext context, String link) async {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return waitingScreen();
        });

    if (!link.contains('#')) {
      if (link == '/') {
        Navigator.of(context).popUntil(ModalRoute.withName('/'));
        setState(() {
          widget.url = "https://tuyensinh.ctu.edu.vn";
        });
      } else {
        link = correctLink(link);
        if (link.contains('tuyensinh.ctu.edu.vn') &&
            link.substring(link.length - 3) != 'pdf' &&
            link.substring(link.length - 3) != 'jpg') {
          if (App.postData[link] == null) await parse(context, link);
          Navigator.of(context).popUntil(ModalRoute.withName('/'));
          setState(() {
            widget.url = link;
          });
        } else if (await browser.canLaunch(link)) {
          await browser.launch(link, forceWebView: false);
        } else {
          pushNotification(context, 'Could not launch $link', '');
        }
      }
    }
  }

  ///Parse posts to Widgets
  List<Widget> parsePost(BuildContext context, dom.Element postcontent) {
    List<Widget> content = new List();
    postcontent.firstChild.children.forEach((element) {
      if (element.className.contains('accordion')) {
        element
            .getElementsByClassName('accordion-inner')
            .forEach((accordionContent) {
          content.add(new ExpansionTile(
            title: new Text(
                accordionContent.getElementsByTagName('h2').first.text),
            children: <Widget>[
              new Container(
                margin: EdgeInsets.all(16.0),
                child: new MarkdownBody(
                  data: html2md.convert(accordionContent.innerHtml.substring(
                      accordionContent.innerHtml.indexOf('</h2>') + 5)),
                  onTapLink: (url) {
                    launch(context, url);
                  },
                ),
              )
            ],
          ));
        });
      } else {
        content.add(new MarkdownBody(
          data: html2md.convert(element.outerHtml),
          onTapLink: (url) {
            launch(context, url);
          },
        ));
        content.add(new SizedBox(
          height: 6.0,
        ));
      }
    });

    if (postcontent.children.length > 1) {
      postcontent.children
          .getRange(1, postcontent.children.length)
          .forEach((element) {
        content.add(new MarkdownBody(
          data: html2md.convert(element.outerHtml),
          onTapLink: (url) {
            launch(context, url);
          },
        ));
      });
    }
    return content;
  }

  ///Parse menu elements in DOM to widgets
  Widget parseMenu(BuildContext context, dom.Element menu) {
    List<Widget> listmenu = new List();
    menu.children.forEach((item) {
      if (item.getElementsByTagName('ul').isNotEmpty) {
        listmenu.add(new ExpansionTile(
          title: new Text(item.getElementsByTagName('a').first.text),
          children: <Widget>[
            new MarkdownBody(
              data: html2md
                  .convert(item.getElementsByTagName('ul').first.innerHtml),
              onTapLink: (url) {
                launch(context, url);
              },
            ),
            new SizedBox(
              height: 6.0,
            )
          ],
        ));
      } else {
        listmenu.add(new ExpansionTile(
          title: new MarkdownBody(
            data: html2md.convert(item.innerHtml),
            onTapLink: (url) {
              launch(context, url);
            },
          ),
        ));
      }
    });

    listmenu.add(new ExpansionTile(
      title: new Text('Liên hệ'),
      children: <Widget>[
        new Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new FlatButton(
              child: new Text(
                  '- Địa chỉ: Đường 3/2, Quận Ninh Kiều, TP. Cần Thơ',
                  style: TextStyle(color: Colors.blue)),
              onPressed: () {
                laucher.launch('https://goo.gl/maps/Yt72WnVJeX42');
              },
            ),
            new FlatButton(
              child: new Text('- Điện thoại: 0292 3872 728',
                  style: TextStyle(color: Colors.blue)),
              onPressed: () {
                laucher.launch('tel:02923872728');
              },
            ),
            new FlatButton(
              child: new Text('- Email: tuyensinh@ctu.edu.vn',
                  style: TextStyle(color: Colors.blue)),
              onPressed: () {
                laucher.launch('mailto:tuyensinh@ctu.edu.vn');
              },
            ),
            new FlatButton(
              child: new Text(
                '- Facebook: ctu.tvts',
                style: TextStyle(color: Colors.blue),
              ),
              onPressed: () {
                laucher.launch('https://fb.com/ctu.tvts/');
              },
            ),
          ],
        )
      ],
    ));
    return new Column(
      children: listmenu,
    );
  }

  ///Convert relative URL to absolute URL of images and parse document
  Future<void> parse(BuildContext context, String url) async {
    var html = await fetch(url);
    var document = parser.parse(html);
    final img = document.body.getElementsByTagName('img').toList();

    List<String> links = new List<String>();
    String tmp;

    img.forEach((value) {
      tmp = getLink(value);
      if (tmp != null) {
        links.add(tmp);
      }
    });

    links.forEach((value) {
      if (value.length > 4 && value.substring(0, 4) != 'http')
        html = html.replaceAll(value, App.link + value);
    });

    document = parser.parse(html);

    App.mainMenu =
        parseMenu(context, document.getElementsByClassName('art-hmenu').first);
    App.blockData = getPosts(context, document, 'art-block');
    App.postData[url] = getPosts(context, document, 'art-post');
    App.titles[url] = document.head.getElementsByTagName('title').first.text;
  }

  ///Get posts from a HTML document by classPrefix
  List<Widget> getPosts(
      BuildContext context, dom.Document document, String classPrefix) {
    List<Widget> listPosts = new List();
    String headerClass = classPrefix + 'header';
    String contentClass = classPrefix + 'content';
    Widget header, content;
    document.getElementsByClassName(classPrefix).toList().forEach((post) {
      header = null;
      content = null;

      if (post.hasContent()) {
        try {
          if (post.getElementsByClassName(headerClass).isNotEmpty) {
            if (post.getElementsByClassName(headerClass).first.text != '')
              header =
                  new Text(post.getElementsByClassName(headerClass).first.text);
          }
        } catch (e) {
          print('get header error -> ${e.toString()}');
        }

        try {
          if (post.getElementsByClassName(contentClass).isNotEmpty) {
            if (post.getElementsByClassName(contentClass).first.text != '')
              content = new Column(
                children: parsePost(
                    context, post.getElementsByClassName(contentClass).first),
              );
          }
        } catch (e) {
          print('get content error -> ${e.toString()}');
        }

        if (header == null && content != null) {
          //add a post without header
          listPosts.add(new Card(
              margin: EdgeInsets.all(10.0),
              child: new Container(
                margin: EdgeInsets.all(16.0),
                child: content,
              )));
        } else if (content == null && header != null) {
          //add a post without content
          listPosts.add(new Card(
              margin: EdgeInsets.all(10.0),
              child: new Container(
                margin: EdgeInsets.all(16.0),
                child: header,
              )));
        } else {
          //add a complete post
          listPosts.add(new Card(
            margin: EdgeInsets.all(10.0),
            child: new Container(
                margin: EdgeInsets.fromLTRB(0.0, 6.0, 0.0, 6.0),
                child: new ExpansionTile(
                  leading: new Icon(
                    Icons.notifications,
                    color: Colors.blueGrey,
                  ),
                  title: header,
                  children: <Widget>[
                    new Container(
                      margin: EdgeInsets.all(16.0),
                      child: content,
                    )
                  ],
                )),
          ));
        }
      }
    });
    return listPosts;
  }
}
