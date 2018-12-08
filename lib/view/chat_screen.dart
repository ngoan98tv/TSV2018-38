import 'dart:async';
import 'package:flutter/material.dart';
import 'package:dialogflow/dialogflow.dart';
import 'package:tuyensinh_ctu/app.dart';
import 'package:tuyensinh_ctu/model/data.dart';
import 'package:url_launcher/url_launcher.dart' as browser;
import 'package:tuyensinh_ctu/view/detail_screen.dart';
import 'package:tuyensinh_ctu/view/message_widget.dart';
import 'package:tuyensinh_ctu/config.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => new _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _textController = new TextEditingController();


  @override
  void initState(){
    super.initState();
    App.messages.insert(0,new ChatMessage(
      text: "Kelly là Chatbot tư vấn, đang trong quá trình huấn luyện, vui lòng sử dụng Tiếng Việt có dấu để nhận được phản hồi tốt nhất.",
      onTap: _launch,
      type: MessageType.sys,
    ));
  }

  ///return a input field
  Widget _buildTextComposer() {
    return new IconTheme(
      data: new IconThemeData(color: Theme.of(context).accentColor),
      child: new Container(
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        child: new Row(
          children: <Widget>[
            new Flexible(
              child: new TextField(
                controller: _textController,
                onSubmitted: _handleSubmitted,
                decoration:
                    new InputDecoration.collapsed(hintText: "Send a message"),
              ),
            ),
            new Container(
              margin: new EdgeInsets.symmetric(horizontal: 4.0),
              child: new IconButton(
                  icon: new Icon(Icons.send),
                  onPressed: () => _handleSubmitted(_textController.text)),
            ),
          ],
        ),
      ),
    );
  }

  ///display response from Dialgoflow
  void showResponse(String response) {
    ChatMessage message = new ChatMessage(
      text: response,
      type: MessageType.other,
      onTap: _launch,
    );
    setState(() {
      App.messages.insert(0, message);
    });
  }

  ///Send a query to Dialogflow and get response message
  Future<String> response(query) async {
    _textController.clear();
    Dialogflow dialogflow = Dialogflow(token: dialogflow_token, sessionId: sessionId);
    AIResponse response = await dialogflow.sendQuery(query);
    return response.getMessageResponse();
  }

  ///Get user input
  void _handleSubmitted(String text) {
    _textController.clear();
    ChatMessage message = new ChatMessage(
      text: text,
      type: MessageType.me,
      onTap: _launch,
    );
    setState(() {
      App.messages.insert(0, message);
    });

    response(text).then((response) {
      showResponse(response);
    }).catchError((error) {
      showResponse(
          "Xin lỗi, Kelly cần kết nối mạng để hoạt động.");
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Chat với Kelly"),
      ),
      body: new Column(children: <Widget>[
        new Flexible(
            child: new ListView.builder(
          padding: new EdgeInsets.all(8.0),
          reverse: true,
          itemBuilder: (_, int index) => App.messages[index],
          itemCount: App.messages.length,
        )),
        new Divider(height: 1.0),
        new Container(
          decoration: new BoxDecoration(color: Theme.of(context).cardColor),
          child: _buildTextComposer(),
        ),
      ]),
    );
  }

  void _launch(String link) {
    if (!link.contains('#')) {
      link = correctLink(link);
      if (link.contains(home) &&
          !(link
              .substring(link.length - 4)
              .contains(new RegExp(r'[.]\w{3}', caseSensitive: false)))) {
        Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => DetailScreen(url: link)));
      } else {
        browser.launch(link, forceWebView: false).catchError((e) {
          print("Error occurred: $e");
        });
      }
    }
  }
}

