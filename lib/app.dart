import 'package:flutter/material.dart';

import 'home.dart';
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
      title: 'Tuyển sinh - Đại học Cần Thơ',
      home: new Home(),
      
      // initialRoute: '/login',
    );
  }
  
}