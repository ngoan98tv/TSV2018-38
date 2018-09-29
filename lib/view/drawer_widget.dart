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

    return listmenu;
  }
}
