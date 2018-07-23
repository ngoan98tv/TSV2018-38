import 'package:html/parser.dart' show parse;
import 'package:http/http.dart' as http;
import 'package:html/dom.dart';
import 'dart:async';
import 'function.dart';

/// fetch information from the URL
Future<Information> fetch(String url) async {
    Information info = new Information();
    
    final response = await http.get(url);
    //final document = parse(response.body);
    final document = check_Img_links(response.body);

    info.title = document.head.getElementsByTagName('title').first.text;
    info.art_hmenu = document.getElementsByClassName('art-hmenu').first.innerHtml;
    info.art_postheader = document.getElementsByClassName('art-postheader').toList();
    info.art_postcontent = document.getElementsByClassName('art-postcontent').toList();
    info.art_blockheader = document.getElementsByClassName('art-blockheader').toList();
    info.art_blockcontent = document.getElementsByClassName('art-blockcontent').toList();

    info.a = document.body.getElementsByTagName('a').toList();
    info.img = document.body.getElementsByTagName('img').toList();

    return info;
}

/// contain information of fetched data
class Information {
  /// page title
  String title;

  /// menu contain in HTML code.
  String art_hmenu;

  /// List of post header elements
  List<Element> art_postheader;

  /// List of post content elements
  List<Element> art_postcontent;

  /// List of block header elements
  List<Element> art_blockheader;

  /// List of block content elements
  List<Element> art_blockcontent;

  /// List of available links
  List<Element> a;

  /// List of images
  List<Element> img;
}
