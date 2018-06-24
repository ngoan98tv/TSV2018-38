import 'dart:async';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:tuyensinh/model/html.dart';

const URL = 'https://tuyensinh.ctu.edu.vn';

Future<http.Response> fetch(String url) async {
  final response = await http.get(url);

  return response;
}

class DataDisplay extends StatefulWidget {
  @override
  _DataDisplayState createState() => _DataDisplayState();
}

class _DataDisplayState extends State<DataDisplay> {
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
              return new TabBarView(
                children: <Widget>[
                  new ListView(
                    scrollDirection: Axis.vertical,
                    padding: EdgeInsets.all(16.0),
                    children: <Widget>[linksRender(snapshot.data.body)],
                  ),
                  new ListView(
                    scrollDirection: Axis.vertical,
                    padding: EdgeInsets.all(16.0),
                    children: <Widget>[headersRender(snapshot.data.headers)],
                  ),
                  new ListView(
                    shrinkWrap: true,
                    padding: EdgeInsets.all(16.0),
                    children: <Widget>[new Text(snapshot.data.body)],
                  )
                ],
              );
        }
      },
    );
  }

  Widget headersRender(Map<String, String> headers) {
    List list = new List<Widget>();

    headers.forEach((key, value) {
      list.add(new Text('$key : $value'));
    });

    return new Column(
      children: list,
      crossAxisAlignment: CrossAxisAlignment.start,
    );
  }

  Widget linksRender(String html) {
    List list = new List<Widget>();

    getDocument(html).forEach((key, value) {
      list.add(new ListTile(
        title: new Text(
          '$key',
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: new Text('$value', overflow: TextOverflow.ellipsis),
        trailing: new Icon(Icons.navigate_next),
        onTap: () {
          showDialog(
            context: context,
            child: new SimpleDialog(
              title: new Text('$key', overflow: TextOverflow.clip),
              children: <Widget>[new Text('$value')],
            ),
          );
        },
      ));
    });

    return new Column(
      children: list,
      crossAxisAlignment: CrossAxisAlignment.start,
    );
  }
}