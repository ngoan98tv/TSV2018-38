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
      //home: new Home(url: 'https://tuyensinh.ctu.edu.vn/gioithieu/ly-do-chon-ctu'),
      //initialRoute: '/login' ,
      routes: {
        '/': (context) => new Loading(url: 'https://tuyensinh.ctu.edu.vn'),
        '/login': (context) => new Login(),
        '/chat': (context) => new Conversation(),
      },
    );
  }
  
}