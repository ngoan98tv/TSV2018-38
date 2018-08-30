import 'package:flutter/material.dart';
import 'package:html/dom.dart' as dom;
import 'package:http/http.dart' as http;
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:html2md/html2md.dart' as html2md;
import 'package:url_launcher/url_launcher.dart' as laucher;
import 'package:html/parser.dart' as parser;
import 'dart:async';
import 'presenter.dart';
import 'app.dart';

/// Loading screen
class Loader extends StatelessWidget {
  final String url;

  ///Loading data from the url, waiting on loading screen
  Loader({Key key, @required this.url}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Loader.fetch(context, url),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return App.waitingScreen(url);
          default:
            if (snapshot.hasError) {
              return App.waitingScreen('Không có kết nối Internet');
            } else {
              return Presenter(url);
            }
        }
      },
    );
  }

  ///Get HTML Document from the URL
  static Future<void> fetch(BuildContext context, String url) async {
    var response = await http.get(url);
    final document = parse(response.body);
    App.mainMenu =
        parseMenu(context, document.getElementsByClassName('art-hmenu').first);
    App.blockData = getPosts(context, document, 'art-block');
    App.postData[url] = getPosts(context, document, 'art-post');
    App.titles[url] = document.head.getElementsByTagName('title').first.text;
  }

  ///Get posts from a HTML document by classPrefix
  static List<Widget> getPosts(
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
              margin: EdgeInsets.fromLTRB(0.0,6.0,0.0,6.0),
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

  ///Parse posts to Widgets
  static List<Widget> parsePost(BuildContext context, dom.Element postcontent) {
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
                    App.launch(context, url);
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
            App.launch(context, url);
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
            App.launch(context, url);
          },
        ));
      });
    }
    return content;
  }

  ///Parse menu elements in DOM to widgets
  static Widget parseMenu(BuildContext context, dom.Element menu) {
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
                App.launch(context, url);
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
              App.launch(context, url);
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
                App.launch(context, 'https://fb.com/ctu.tvts/');
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
  static dom.Document parse(String html) {
    final document = parser.parse(html);
    final img = document.body.getElementsByTagName('img').toList();

    List<String> links = new List<String>();
    String tmp;

    img.forEach((value) {
      tmp = App.getLink(value);
      if (tmp != null) {
        links.add(tmp);
      }
    });

    links.forEach((value) {
      if (value.length > 4 && value.substring(0, 4) != 'http')
        html = html.replaceAll(value, homeLink + value);
    });

    return parser.parse(html);
  }
}
