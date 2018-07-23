import 'package:html2md/html2md.dart' as html2md;
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:html/dom.dart' as dom;
import 'package:flutter/material.dart';
import 'function.dart';

/// interface of posts
List<Widget> postContent(BuildContext context, List<dom.Element> headers, List<dom.Element> posts) {
  List<Widget> list = new List();

  for (var i = 0; i < headers.length; i++) {
    list.add(new Card(
      margin: EdgeInsets.all(10.0),
      child: new ExpansionTile(
        leading: new Icon(
          Icons.notifications,
          color: Colors.blueGrey,
        ),
        title: new Text(
          headers[i].text,
          style: new TextStyle(color: Colors.blueGrey),
        ),
        children: <Widget>[
          new Container(
            margin: EdgeInsets.all(15.0),
            child: new MarkdownBody(
              data: html2md.convert(posts[i + 1].innerHtml),
              onTapLink: (url){
                launch(context, url);
              },
            ),
          )
        ],
      ),
    ));
  }

  return list;
}
