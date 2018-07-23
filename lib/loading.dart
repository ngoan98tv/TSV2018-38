import 'package:flutter/material.dart';
import 'package:tuyensinh/data.dart';
import 'package:tuyensinh/error.dart';
import 'package:tuyensinh/main_view.dart';

/// Loading screen
class Loading extends StatefulWidget {
  final String url;

  ///Loading data from the url, waiting on loading screen
  Loading({Key key, @required this.url}) : super(key: key);

  @override
  _LoadingState createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: fetch(widget.url),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return _loading();
          case ConnectionState.none:
            pushNotification(context, snapshot.connectionState.toString());
            break;
          default:
            if (snapshot.hasError) {
              pushNotification(context, snapshot.error.toString());
            } else {
              return MainView(info: snapshot.data);
            }
        }
      },
    );
  }

  /// Return loading screen
  Widget _loading() {
    return new Container(
        margin: EdgeInsets.all(0.0),
        color: Colors.white,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              new Image.asset(
                'assets/logo_dhct.png',
                height: 170.0,
                width: 170.0,
              ),
              new Container(
                margin: EdgeInsets.all(5.0),
                child: new LinearProgressIndicator(),
              )
            ]));
  }
}
