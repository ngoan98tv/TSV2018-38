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
      future: fetch(context, widget.url),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return _loading();
          case ConnectionState.none:
            pushNotification(context, 'No connection.', snapshot.error.toString());
            break;
          default:
            if (snapshot.hasError) {
              pushNotification(context, 'An error occurred while fetching data', snapshot.error.toString());
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
                child: Text(widget.url,
                    style: TextStyle(
                        fontSize: 10.0,
                        fontWeight: FontWeight.w100,
                        decoration: TextDecoration.none,
                        color: Colors.blueGrey)),
              ),
              new Container(
                margin: EdgeInsets.all(16.0),
                child: new LinearProgressIndicator(),
              )
            ]));
  }
}
