import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'model/data.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: AppBar(
          title: new Text('Trang chủ'),
        ),
        body: new ResponseDisplay(),
    );
  }
}
