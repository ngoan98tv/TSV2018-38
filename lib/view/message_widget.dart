import 'package:flutter/material.dart';
import 'package:tuyensinh_ctu/model/data.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class ChatMessage extends StatelessWidget {
  ChatMessage({this.text, this.type, this.onTap});

  final String text;
  final MarkdownTapLinkCallback onTap;
  final MessageType type;

  List<Widget> otherMessage(context) {
    return <Widget>[
      new Container(
        width: 50.0,
        height: 50.0,
        margin: const EdgeInsets.only(right: 8.0),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
                        image: new DecorationImage(
                            fit: BoxFit.fill,
                            image: AssetImage("assets/placeholder.png")
                        )
        ),
      ),
      new Expanded(
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  color: Colors.blue[200]),
              margin: const EdgeInsets.fromLTRB(0.0, 5.0, 16.0, 0.0),
              padding: const EdgeInsets.fromLTRB(12.0, 6.0, 12.0, 6.0),
              child: new MarkdownBody(
                data: text,
                onTapLink: onTap,
              ),
            ),
          ],
        ),
      ),
    ];
  }

  List<Widget> myMessage(context) {
    return <Widget>[
      new Expanded(
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            new Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  color: Colors.grey),
              margin: const EdgeInsets.fromLTRB(16.0, 5.0, 0.0, 0.0),
              padding: const EdgeInsets.fromLTRB(12.0, 6.0, 12.0, 6.0),
              child: new Text(
                text,
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    ];
  }

  List<Widget> sysMessage(context) {
    return <Widget>[
      new Expanded(
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            new Icon(Icons.info, color: Colors.grey,),
            new Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(25.0)),
              ),
              margin: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 0.0),
              padding: const EdgeInsets.all(12.0),
              child: new Text(
                text,
                style: TextStyle(color: Colors.grey),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      child: new Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: MessageType.me == type
              ? myMessage(context)
              : MessageType.other == type
                  ? otherMessage(context)
                  : sysMessage(context)),
    );
  }
}
