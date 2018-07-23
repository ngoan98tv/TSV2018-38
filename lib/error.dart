import 'dart:async';
import 'package:flutter/material.dart';

/// Notify an error
Future<Null> pushNotification(BuildContext context, String error) async {
  return showDialog<Null>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return new AlertDialog(
        title: new Text("What's happening!"),
        content: new SingleChildScrollView(
          child: new ListBody(
            children: <Widget>[
              new Text(
                error,
                style: new TextStyle(color: Colors.redAccent),
              ),
            ],
          ),
        ),
        actions: <Widget>[
          new RaisedButton(
            child: new Text('OK'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
