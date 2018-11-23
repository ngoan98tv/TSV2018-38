import 'package:flutter/material.dart';
import 'package:html/dom.dart' as dom;
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:url_launcher/url_launcher.dart' as laucher;
import 'package:html2md/html2md.dart' as html2md;

class DrawerMenu extends StatelessWidget {
  final dom.Element content;
  final MarkdownTapLinkCallback onTap;

  const DrawerMenu({Key key, this.content, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new Drawer(
        child: new ListView(
      children: parseContent(),
    ));
  }

  ///Parse menu elements in DOM to widgets
  List<Widget> parseContent() {
    List<Widget> listmenu = new List();
    listmenu.add(DrawerHeader(
      child: new Image.asset('assets/logo_dhct.png'),
    ));
    content.children.forEach((item) {
      if (item.getElementsByTagName('ul').isNotEmpty) {
        listmenu.add(new ExpansionTile(
          title: new Text(item.getElementsByTagName('a').first.text),
          children: <Widget>[
            new MarkdownBody(
              data: html2md
                  .convert(item.getElementsByTagName('ul').first.innerHtml),
              onTapLink: onTap,
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
            onTapLink: onTap,
          ),
        ));
      }
    });

    listmenu.add(new Column(
      children: <Widget>[
        new FlatButton(
          color: Colors.amber,
          child: new Row(
            children: <Widget>[
              new Icon(
                Icons.location_city,
                size: 18.0,
              ),
              new Text(' Đường 3/2, Q. Ninh Kiều, TP. Cần Thơ'),
            ],
          ),
          onPressed: () {
            laucher.launch('https://goo.gl/maps/Yt72WnVJeX42');
          },
        ),
        new FlatButton(
          color: Colors.blue,
          child: new Row(
            children: <Widget>[
              new Icon(
                Icons.phone,
                size: 18.0,
              ),
              new Text(' 0292 3872 728')
            ],
          ),
          onPressed: () {
            laucher.launch('tel:02923872728');
          },
        ),
        new FlatButton(
          color: Colors.deepOrange,
          child: new Row(
            children: <Widget>[
              new Icon(
                Icons.email,
                size: 18.0,
              ),
              new Text(' tuyensinh@ctu.edu.vn')
            ],
          ),
          onPressed: () {
            laucher.launch('mailto:tuyensinh@ctu.edu.vn');
          },
        ),
        new FlatButton(
          color: Colors.indigo,
          child: new Row(
            children: <Widget>[
              new Icon(
                Icons.feedback,
                size: 18.0,
              ),
              new Text(' facebook: ctu.tvts')
            ],
          ),
          onPressed: () {
            laucher.launch('https://facebook.com/ctu.tvts/');
          },
        ),
        new FlatButton(
          color: Colors.teal,
          child: new Row(
            children: <Widget>[
              new Icon(
                Icons.link,
                size: 18.0,
              ),
              new Text(' tuyensinh.ctu.edu.vn')
            ],
          ),
          onPressed: () {
            laucher.launch('https://tuyensinh.ctu.edu.vn/');
          },
        ),
      ],
    ));

    return listmenu;
  }
}
