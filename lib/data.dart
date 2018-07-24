import 'package:http/http.dart' as http;
import 'package:html/dom.dart' as dom;
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:html2md/html2md.dart' as html2md;
import 'package:url_launcher/url_launcher.dart' as laucher;

import 'dart:async';
import 'helper.dart';

/// the first time fetch information from the URL
Future<Information> fetch_1(BuildContext context, String url) async {
  var response;

  try {
    response = await http.get(url);
  } catch (e) {
    print(e.toString());
  }

  final document = Helper.parse(response.body);

  Information.art_hmenu = new Column(
    children: Information.parseMenu(
        context, document.getElementsByClassName('art-hmenu').first),
  );
  // new MarkdownBody(
  //   data: html2md
  //       .convert(document.getElementsByClassName('art-hmenu').first.innerHtml),
  //   onTapLink: (url) {
  //     Helper.launch(context, url);
  //   },
  // );

  Information.art_block = new List();
  Widget tmp;

  document.getElementsByClassName('art-block').toList().forEach((block) {
    try {
      tmp = Information.getPost(
          context, block, 'art-blockheader', 'art-blockcontent');
      if (tmp != null) Information.art_block.add(tmp);
    } catch (e) {
      print('art-block error -> ${e.toString()}');
    }
  });

  return new Information(context, document);
}

/// fetch information from the URL
Future<Information> fetch(BuildContext context, String url) async {
  final response = await http.get(url);
  final document = Helper.parse(response.body);

  return new Information(context, document);
}

/// contain information of fetched data
class Information {
  /// Page title
  Widget title;

  /// Navigation menu
  static Widget art_hmenu;

  /// List of posts
  List<Widget> art_post;

  /// List of blocks
  static List<Widget> art_block;

  /// Create an information object from HTML document
  Information(BuildContext context, dom.Document document) {
    Widget tmp;

    this.title =
        new Text(document.head.getElementsByTagName('title').first.text);

    this.art_post = new List();

    document.getElementsByClassName('art-post').toList().forEach((post) {
      try {
        tmp = getPost(context, post, 'art-postheader', 'art-postcontent');
        if (tmp != null) this.art_post.add(tmp);
      } catch (e) {
        print('art-post error -> ${e.toString()}');
      }
    });
  }

  /// return a widget of the post from a post element
  static Widget getPost(BuildContext context, dom.Element post,
      String headerClass, String contentClass) {
    Widget header, content;
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
          // content = new MarkdownBody(
          //   data: html2md.convert(
          //       post.getElementsByClassName(contentClass).first.innerHtml),
          //   onTapLink: (url) {
          //     Helper.launch(context, url);
          //   },
          // );
        }
      } catch (e) {
        print('get content error -> ${e.toString()}');
      }

      if (header == null && content == null) {
        print('returning null');
        return null;
      }

      if (header == null) {
        print('returning a post without header');
        return new Card(
            margin: EdgeInsets.all(10.0),
            child: new Container(
              margin: EdgeInsets.all(16.0),
              child: content,
            ));
      }
      if (content == null) {
        print('returning a post without content');
        return new Card(
            margin: EdgeInsets.all(10.0),
            child: new Container(
              margin: EdgeInsets.all(16.0),
              child: header,
            ));
      } else {
        print('returning a full post');
        return new Card(
          margin: EdgeInsets.all(10.0),
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
          ),
        );
      }
    }
    return null;
  }

  static List<Widget> parsePost(BuildContext context, dom.Element postcontent) {
    List<Widget> content = new List();
    postcontent.firstChild.children.forEach((element) {
      if (element.className.contains('accordion')) {
        print('>>> accordion detected');
        element
            .getElementsByClassName('accordion-inner')
            .forEach((accordion_inner) {
          content.add(new ExpansionTile(
            title:
                new Text(accordion_inner.getElementsByTagName('h2').first.text),
            children: <Widget>[
              new Container(
                margin: EdgeInsets.all(16.0),
                child: new MarkdownBody(
                  data: html2md.convert(accordion_inner.innerHtml.substring(
                      accordion_inner.innerHtml.indexOf('</h2>') + 5)),
                  onTapLink: (url) {
                    Helper.launch(context, url);
                  },
                ),
              )
            ],
          ));
        });
      } else {
        print('>>>out of accordion');
        content.add(new MarkdownBody(
          data: html2md.convert(element.outerHtml),
          onTapLink: (url) {
            Helper.launch(context, url);
          },
        ));
        content.add(new SizedBox(
          height: 6.0,
        ));
      }
    });
    
    if (postcontent.children.length > 1) {
        postcontent.children.getRange(1, postcontent.children.length).forEach((element){
          content.add(new MarkdownBody(
          data: html2md.convert(element.outerHtml),
          onTapLink: (url) {
            Helper.launch(context, url);
          },
        ));
        });
        
    }
    return content;
  }

  static List<Widget> parseMenu(BuildContext context, dom.Element menu) {
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
                Helper.launch(context, url);
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
              Helper.launch(context, url);
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
                Helper.launch(context, 'https://fb.com/ctu.tvts/');
              },
            ),
          ],
        )
      ],
    ));
    return listmenu;
  }
}
