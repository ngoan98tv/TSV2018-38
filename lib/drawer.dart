import 'package:flutter/material.dart';

Widget mainDrawer() {
  return new Drawer(
    child: new ListView(
      children: <Widget>[
        new DrawerHeader(
          child: new Image.asset('assets/logo_dhct.png'),
        ),
      ],
    ),
  );
}
