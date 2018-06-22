import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home>{
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: new Text('Trang chủ'),
      ),
      body: Container(
        child: new Center(
          child: new Text('Chào mừng đến trang chủ Đại học Cần Thơ'),
        ),
      ),
    );
  }

}