import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:html2md/html2md.dart' as html2md;
import 'package:html/dom.dart' as dom;
import 'package:tuyensinh_ctu/model/data.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'package:tuyensinh_ctu/view/table_widget.dart';

class Post extends StatelessWidget {
  final MarkdownTapLinkCallback onTap;
  final dom.Element post;

  Post({Key key, @required this.post, @required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String title;
    List<Widget> content;

    try {
      title = getTitle;
    } catch (e) {
      print('>>> Title error: $e');
      print(">>> ${post.toString()}");
    }

    try {
      content = getContent;
    } catch (e) {
      print(">>> Content error: $e");
      print(">>> ${post.toString()}");
    }

    if (title == null && content == null) {
      return Card(child: new Text('Empty!'));
    } else if (title == null) {
      return Card(
          margin: EdgeInsets.all(6.0),
          child: Container(
            margin: EdgeInsets.fromLTRB(0.0, 6.0, 0.0, 6.0),
            padding: EdgeInsets.all(6.0),
            child: Column(children: content),
          ));
    } else if (content == null) {
      return Card(
          margin: EdgeInsets.all(6.0),
          child: Container(
              margin: EdgeInsets.fromLTRB(0.0, 6.0, 0.0, 6.0),
              padding: EdgeInsets.all(6.0),
              child: Text(
                title,
                style: Theme.of(context).textTheme.title,
              )));
    }
    return Card(
      margin: EdgeInsets.all(6.0),
      child: Container(
          margin: EdgeInsets.fromLTRB(0.0, 6.0, 0.0, 6.0),
          padding: EdgeInsets.all(6.0),
          child: ExpansionTile(
              // leading: Icon(
              //   Icons.notifications,
              //   color: Colors.blueGrey,
              // ),
              title: Text(title),
              children: content)),
    );
  }

  List<Widget> get getContent {
    dom.Element postcontent =
        post.getElementsByClassName('art-postcontent').first ??
            post.getElementsByClassName('art-blockcontent').first;
    List<Widget> content = new List();
    postcontent.firstChild.children.forEach((element) {
      if (element.className.contains('accordion')) {
        element
            .getElementsByClassName('accordion-inner')
            .forEach((accordionContent) {
          content.add(new ExpansionTile(
            title: new Text(
                accordionContent.getElementsByTagName('h2').first.text),
            children: <Widget>[
              new Container(
                margin: EdgeInsets.all(16.0),
                child: new MarkdownBody(
                  data: html2md.convert(accordionContent.innerHtml.substring(
                      accordionContent.innerHtml.indexOf('</h2>') + 5)),
                  onTapLink: onTap,
                ),
              )
            ],
          ));
        });
      } else if (element.className.contains('avVideo')) {
        var videoURL = correctLink(element.innerHtml.substring(
            element.innerHtml.indexOf('file') + 8,
            element.innerHtml.indexOf('mp4') + 3));
        content.add(new Chewie(
          new VideoPlayerController.network(videoURL),
          aspectRatio: 3 / 2,
          autoPlay: true,
          looping: true,
        ));
      } else if (element.outerHtml.contains('table')) {
        print(">>>> Table detected");
        content.add(TableBuilder(tableElement: element, onTap: onTap,));
      } else {
        content.add(new MarkdownBody(
          data: html2md.convert(element.outerHtml),
          onTapLink: onTap,
        ));
        content.add(new SizedBox(
          height: 6.0,
        ));
      }
    });

    if (postcontent.children.length > 1) {
      postcontent.children
          .getRange(1, postcontent.children.length)
          .forEach((element) {
        content.add(new MarkdownBody(
          data: html2md.convert(element.outerHtml),
          onTapLink: onTap,
        ));
      });
    }
    return content;
  }

  String get getTitle =>
      post.getElementsByClassName('art-postheader').first.text ??
      post.getElementsByClassName('art-blockheader').first.text;
}
