import 'package:flutter/material.dart';
import 'data.dart';
import 'helper.dart';
import 'main_view.dart';

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
            return Helper.waitingScreen(widget.url);
          case ConnectionState.none:
            return Helper.waitingScreen('Không có kết nối Internet');
          default:
            if (snapshot.hasError) {
              return Helper.waitingScreen('Không có kết nối Internet');
            } else {
              return MainView(info: snapshot.data);
            }
        }
      },
    );
  }
}

/// Loading screen for the first time
class Loading_1 extends StatefulWidget {
  final String url;

  ///Loading data from the url, waiting on loading screen
  Loading_1({Key key, @required this.url}) : super(key: key);

  @override
  _Loading_1State createState() => _Loading_1State();
}

class _Loading_1State extends State<Loading_1> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: fetch_1(context, widget.url),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return Helper.waitingScreen(widget.url);
          case ConnectionState.none:
            return Helper.waitingScreen('Không có kết nối Internet');
          default:
            if (snapshot.hasError) {
              return Helper.waitingScreen('Không có kết nối Internet');
            } else {
              return MainView(info: snapshot.data);
            }
        }
      },
    );
  }
}