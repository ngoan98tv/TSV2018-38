import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:html2md/html2md.dart' as html2md;
import 'package:html/dom.dart' as dom;
import 'package:tuyensinh_ctu/model/data.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'package:url_launcher/url_launcher.dart' as browser;
import 'package:tuyensinh_ctu/view/table_widget.dart';
import 'package:tuyensinh_ctu/app.dart';

class DetailScreen extends StatefulWidget {
  final String url;

  DetailScreen({Key key, @required this.url}) : super(key: key);

  @override
  _DetailScreenState createState() => _DetailScreenState(url);
}

class _DetailScreenState extends State<DetailScreen> {
  String _url;
  VideoPlayerController videoControll;

  _DetailScreenState(this._url);

  @override
  void dispose() {
    super.dispose();
    videoControll.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (App.posts[_url] != null)
      return getScaffold(App.posts[_url].last);
    else
      return FutureBuilder(
        future: parse(_url),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Scaffold(
                  appBar: AppBar(
                    title: Text(_url),
                  ),
                  body: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Center(child: CircularProgressIndicator())
                      ]));
            default:
              if (snapshot.hasError) {
                print("Load error: ${snapshot.error.toString()}");
                return Scaffold(
                    appBar: AppBar(
                      title: Text(_url),
                    ),
                    body: Center(
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                          new Icon(Icons.warning, color: Colors.yellow[600], size: 32.0,),
                          new SizedBox(height: 16.0),
                          new Text('Không tìm thấy dữ liệu.'),
                          new SizedBox(height: 16.0),
                          new Text('Kiểm tra kết nối mạng và thử lại.'),
                          new SizedBox(height: 16.0),
                          new RaisedButton(
                            child: new Text('Thử lại'),
                            onPressed: () {
                              _load(_url);
                            },
                          )
                        ])));
              } else {
                return getScaffold(App.posts[_url].last);
              }
          }
        },
      );
  }

  Scaffold getScaffold(dom.Element post) {
    String title = getTitle(post) ?? 'Nội dung';
    List<Widget> content = getContent(post);
    if (content == null) {
      return Scaffold(
        appBar: AppBar(
          title: new Text(title),
        ),
        body: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[new Text('Không có nội dung.')],
          ),
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: new Text(title),
      ),
      body: Container(
        padding: EdgeInsets.all(12.0),
        child: ListView.builder(
            itemCount: content.length,
            itemBuilder: (context, i) {
              return content[i];
            }),
      ),
    );
  }

  List<Widget> getContent(dom.Element post) {
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
                  onTapLink: _load,
                ),
              )
            ],
          ));
        });
      } else if (element.outerHtml.contains('avVideo')) {
        var videoURL = correctLink(element.innerHtml.substring(
            element.innerHtml.indexOf('file') + 8,
            element.innerHtml.indexOf('mp4') + 3));
        videoControll = new VideoPlayerController.network(videoURL);
        content.add(new Chewie(
          videoControll,
          aspectRatio: 3 / 2,
          autoPlay: true,
          looping: true,
        ));
      } else if (element.outerHtml.contains('table')) {
        print(">>>> Table detected");
        content.add(TableBuilder(
          tableElement: element,
          onTap: _load,
        ));
      } else {
        content.add(new MarkdownBody(
          data: html2md.convert(element.outerHtml),
          onTapLink: _load,
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
          onTapLink: _load,
        ));
      });
    }
    return content;
  }

  String getTitle(dom.Element post) {
    return post.getElementsByClassName('art-postheader').first.text ??
        post.getElementsByClassName('art-blockheader').first.text;
  }

  void _load(String link) {
    if (!link.contains('#')) {
      link = correctLink(link);
      if (link.contains(App.home) &&
          !(link
              .substring(link.length - 4)
              .contains(new RegExp(r'[.]\w{3}', caseSensitive: false)))) {
        setState(() {
          _url = link;
        });
      }
    } else {
      browser.launch(link, forceWebView: false);
    }
  }
}
