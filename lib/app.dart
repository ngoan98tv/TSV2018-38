import 'package:flutter/material.dart';
import 'loading.dart';
import 'chat.dart';

///Booting and setting up routes
class Booter extends StatefulWidget {
  @override
  _BooterState createState() => _BooterState();
}

class _BooterState extends State<Booter> {
  @override
  Widget build(BuildContext context) {

    return new MaterialApp(
      title: 'Thông tin tuyển sinh CTU',
      routes: {
        '/': (context) => new Loading_1(url: 'https://tuyensinh.ctu.edu.vn'),
        '/chat': (context) => new Conversation(),
      },
    );
  }
  
}