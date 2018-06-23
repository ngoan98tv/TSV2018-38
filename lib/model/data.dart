import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

const URL = 'https://tuyensinh.ctu.edu.vn/';

Future<http.Response> fetch(String url) async {
  final response = await http.get(url);

  return response;
}

class ResponseDisplay extends StatefulWidget {
  @override
  _ResponseDisplayState createState() => _ResponseDisplayState();
}

class _ResponseDisplayState extends State<ResponseDisplay> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<http.Response>(
      future: fetch(URL),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
            return new Text('Press button to start');
          case ConnectionState.waiting:
            return new LinearProgressIndicator();
          default:
            if (snapshot.hasError)
              return new Text(
                'Error: ${snapshot.error}',
                style: new TextStyle(color: Colors.redAccent),
              );
            else
              return new ListView(
                scrollDirection: Axis.vertical,
                padding: EdgeInsets.all(16.0),
                children: <Widget>[
                  new Text(
                    "Response Headers",
                    style: new TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 18.0),
                  ),
                  new Card(
                      margin: EdgeInsets.fromLTRB(0.0, 8.0, 0.0, 16.0),
                      child: new Container(
                        child: headersRendering(snapshot.data.headers),
                        padding: EdgeInsets.all(16.0),
                      )),
                  new Text(
                    "Response Body",
                    style: new TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 18.0),
                  ),
                  new Card(
                      margin: EdgeInsets.fromLTRB(0.0, 8.0, 0.0, 16.0),
                      child: new Container(
                        child: new Text(snapshot.data.body),
                        padding: EdgeInsets.all(16.0),
                      )),
                ],
              );
        }
      },
    );
  }

  Widget headersRendering(Map<String, String> headers) {
    List list = new List<Widget>();

    headers.forEach((key, value) {
      list.add(new Text('$key : $value'));
    });

    return new Column(
      children: list,
      crossAxisAlignment: CrossAxisAlignment.start,
    );
  }
}
