import 'package:flutter/material.dart';

Widget mainDrawer(BuildContext context, Widget content) {
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
