// import 'package:flutter/material.dart';
// import 'package:flutter_dialogflow/flutter_dialogflow.dart';
// import 'dart:async';
// import 'app.dart';

// class Conversation extends StatefulWidget {
//   @override
//   _ConversationState createState() => new _ConversationState();
// }

// class _ConversationState extends State<Conversation> {
//   final List<ChatMessage> _messages = <ChatMessage>[];
//   final TextEditingController _textController = new TextEditingController();

//   ///return a input field
//   Widget _buildTextComposer() {
//     return new IconTheme(
//       data: new IconThemeData(color: Theme.of(context).accentColor),
//       child: new Container(
//         margin: const EdgeInsets.symmetric(horizontal: 8.0),
//         child: new Row(
//           children: <Widget>[
//             new Flexible(
//               child: new TextField(
//                 controller: _textController,
//                 onSubmitted: _handleSubmitted,
//                 decoration:
//                     new InputDecoration.collapsed(hintText: "Send a message"),
//               ),
//             ),
//             new Container(
//               margin: new EdgeInsets.symmetric(horizontal: 4.0),
//               child: new IconButton(
//                   icon: new Icon(Icons.send),
//                   onPressed: () => _handleSubmitted(_textController.text)),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   ///display response from Dialgoflow
//   void showResponse(String response) {
//     ChatMessage message = new ChatMessage(
//       text: response,
//       type: false,
//     );
//     setState(() {
//       _messages.insert(0, message);
//     });
//   }

//   ///Send a query to Dialogflow and get response message
//   Future<String> response(query) async {
//     _textController.clear();
//     Dialogflow dialogflow = Dialogflow(token: App.dialogflowToken);
//     AIResponse response = await dialogflow.sendQuery(query);
//     return response.getMessageResponse();
//   }

//   ///Get user input
//   void _handleSubmitted(String text) {
//     _textController.clear();
//     ChatMessage message = new ChatMessage(
//       text: text,
//       type: true,
//     );
//     setState(() {
//       _messages.insert(0, message);
//     });

//     response(text).then((response) {
//       showResponse(response);
//     }).catchError((error) {
//       showResponse(
//           "Xin lỗi, Kelly cần kết nối mạng để hoạt động.");
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return new Scaffold(
//       appBar: new AppBar(
//         title: new Text("Chat với Kelly"),
//       ),
//       body: new Column(children: <Widget>[
//         new Flexible(
//             child: new ListView.builder(
//           padding: new EdgeInsets.all(8.0),
//           reverse: true,
//           itemBuilder: (_, int index) => _messages[index],
//           itemCount: _messages.length,
//         )),
//         new Divider(height: 1.0),
//         new Container(
//           decoration: new BoxDecoration(color: Theme.of(context).cardColor),
//           child: _buildTextComposer(),
//         ),
//       ]),
//     );
//   }
// }

// class ChatMessage extends StatelessWidget {
//   ChatMessage({this.text, this.type});

//   final String text;
//   final bool type;

//   List<Widget> otherMessage(context) {
//     return <Widget>[
//       new Container(
//         margin: const EdgeInsets.only(right: 8.0),
//         child:
//             new CircleAvatar(child: new Image.asset("assets/placeholder.png")),
//       ),
//       new Expanded(
//         child: new Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: <Widget>[
//             new Container(
//               decoration: BoxDecoration(
//                   borderRadius: BorderRadius.all(Radius.circular(5.0)),
//                   color: Colors.blue),
//               margin: const EdgeInsets.fromLTRB(0.0, 5.0, 16.0, 0.0),
//               padding: const EdgeInsets.fromLTRB(12.0, 6.0, 12.0, 6.0),
//               child: new Text(
//                 text,
//                 style: TextStyle(color: Colors.white),
//               ),
//             ),
//           ],
//         ),
//       ),
//     ];
//   }

//   List<Widget> myMessage(context) {
//     return <Widget>[
//       new Expanded(
//         child: new Column(
//           crossAxisAlignment: CrossAxisAlignment.end,
//           children: <Widget>[
//             new Container(
//               decoration: BoxDecoration(
//                   borderRadius: BorderRadius.all(Radius.circular(5.0)),
//                   color: Colors.grey),
//               margin: const EdgeInsets.fromLTRB(16.0, 5.0, 0.0, 0.0),
//               padding: const EdgeInsets.fromLTRB(12.0, 6.0, 12.0, 6.0),
//               child: new Text(
//                 text,
//                 style: TextStyle(color: Colors.white),
//               ),
//             ),
//           ],
//         ),
//       ),
//     ];
//   }

//   @override
//   Widget build(BuildContext context) {
//     return new Container(
//       margin: const EdgeInsets.symmetric(vertical: 10.0),
//       child: new Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: this.type ? myMessage(context) : otherMessage(context),
//       ),
//     );
//   }
// }
