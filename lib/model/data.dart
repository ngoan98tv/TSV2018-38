import 'package:html/dom.dart' as dom;
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:tuyensinh/app.dart';
import 'package:path_provider/path_provider.dart';
import 'package:html/parser.dart' as parser;

///Parse the document into App data
Future<void> parse(String url) async {

  print('>>> parsing $url');

  var html;
  final path = await _localPath;
  var file = File('$path/${url.hashCode}.txt');

  await fetch(url).then((response) {
    html = response;
    file.writeAsString(html).then((value) {
      print("Write complete: ${value.path}");
    }).catchError((e) {
      print("File write error: $e");
    });
  }).catchError((e) async {
    await file.readAsString().then((value) {
      html = value;
      print("Read complete: ${file.path}");
    }).catchError((e) {
      print("File read error: $e");
    });
  });

  var document = parser.parse(html);
  final img = document.body.getElementsByTagName('img').toList();

  List<String> links = new List<String>();
  String tmp;

  img.forEach((value) {
    tmp = getLink(value);
    if (tmp != null) {
      links.add(tmp);
    }
  });

  links.forEach((value) {
    if (value.length > 4 && value.substring(0, 4) != 'http')
      html = html.replaceAll(value, App.home + value);
  });

  document = parser.parse(html);

  App.menu = document.getElementsByClassName('art-hmenu').first;
  App.posts[url] = getPosts(document);
  App.titles[url] = document.head.getElementsByTagName('title').first.text;

  print('>>> parsing complete.');
}

///Get HTML Document from the URL
Future<String> fetch(String url) async {
  var response = await http.get(url);
  return response.body;
}

///Get local directory for store data
Future<String> get _localPath async {
  final directory = await getApplicationDocumentsDirectory();
  return directory.path;
}

///Get posts elements from the HTML document
List<dom.Element> getPosts(dom.Document document) {
  List<dom.Element> listPost = document.getElementsByClassName('art-post').toList();
  listPost.removeWhere((element) => element.text.trim() == '');
  return listPost;
}

///Get link from a DOM object
String getLink(dom.Element element) {
  String tmp;
  element.attributes.forEach((k, v) {
    if (k.toString() == 'src' || k.toString() == 'href') {
      tmp = v.toString();
    }
  });
  return tmp;
}

///Correct a link to http standard
String correctLink(String url) {
  if (url == '/') return App.home;
  if (!url.contains(r'http.*')) return App.home + url;
  return url;
}
