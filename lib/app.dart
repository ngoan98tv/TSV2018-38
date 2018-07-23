import 'package:flutter/material.dart';
import 'loading.dart';
import 'login.dart';
import 'chat.dart';

class TuyenSinh extends StatefulWidget {
  @override
  _TuyenSinhState createState() => _TuyenSinhState();
}

class _TuyenSinhState extends State<TuyenSinh> {
  @override
  Widget build(BuildContext context) {

    return new MaterialApp(
      title: 'Thông tin tuyển sinh CTU',
      routes: {
        '/': (context) => new Loading_1(url: 'https://tuyensinh.ctu.edu.vn'),
        '/login': (context) => new Login(),
        '/chat': (context) => new Conversation(),
      },
    );
  }
  
}