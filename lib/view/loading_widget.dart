import 'package:flutter/material.dart';

class LoadingWidget extends StatelessWidget {
  final String message;

  const LoadingWidget({Key key, this.message = 'Đang tải...'})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new Opacity(
        opacity: 0.7,
        child: new AlertDialog(
          title: new Text(message),
          content: LinearProgressIndicator(),
        ));
  }
}
