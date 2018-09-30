import 'package:flutter/material.dart';

class LoadingScreen extends StatelessWidget {
  final String message;
  final VoidCallback reload;
  final bool allowReload;

  const LoadingScreen(
      {Key key, @required this.message, this.reload, this.allowReload = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new Container(
        margin: EdgeInsets.all(0.0),
        color: Colors.white,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              new Image.asset(
                'assets/logo_dhct.png',
                height: 170.0,
                width: 170.0,
              ),
              new Container(
                margin: EdgeInsets.all(16.0),
                child: Text(message,
                    style: TextStyle(
                        fontSize: 10.0,
                        fontWeight: FontWeight.w100,
                        decoration: TextDecoration.none,
                        color: Colors.blueGrey)),
              ),
              allowReload
                  ? new OutlineButton(
                      child: Text(
                        'Tải lại',
                        style: Theme.of(context).textTheme.body1,
                      ),
                      onPressed: reload,
                    )
                  : new SizedBox(),
              new Container(
                margin: EdgeInsets.all(16.0),
                child: new LinearProgressIndicator(),
              )
            ]));
  }
}
