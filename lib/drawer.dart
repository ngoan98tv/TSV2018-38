import 'package:flutter/material.dart';
import 'package:html2md/html2md.dart' as html2md;
import 'package:flutter_markdown/flutter_markdown.dart';
import 'function.dart';

Widget mainDrawer(BuildContext context, String content) {
  return new Drawer(
    child: new ListView(
      children: <Widget>[
        new DrawerHeader(
          child: new Image.asset('assets/logo_dhct.png'),
        ),
        new MarkdownBody(
          data: html2md.convert(content),
          onTapLink: (url){
            launch(context, url);
          },
        )
      ],
    ),
  );
}