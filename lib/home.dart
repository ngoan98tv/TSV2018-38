import 'package:flutter/material.dart';

import 'model/data.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return new DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
            title: TabBar(
          tabs: <Widget>[
            Tab(text: 'Menu', icon: Icon(Icons.link)),
            Tab(text: 'Headers', icon: Icon(Icons.short_text)),
            Tab(text: 'HTML', icon: Icon(Icons.code))
          ],
        )),
        body: DataDisplay()
      ),
    );
  }
}
