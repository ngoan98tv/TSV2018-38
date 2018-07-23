import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as parser;
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart' as browser;
import 'error.dart';
import 'loading.dart';

const homeLink = 'https://tuyensinh.ctu.edu.vn';

/// containing static funtions
class Helper {
  /// return a document from HTML (correct images links)
  static dom.Document parse(String html) {
    final document = parser.parse(html);
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
        html = html.replaceAll(value, homeLink + value);
    });

    return parser.parse(html);
  }

  /// get link of an element
  static String getLink(dom.Element element) {
    String tmp;
    element.attributes.forEach((k, v) {
      if (k.toString() == 'src' || k.toString() == 'href') {
        tmp = v.toString();
      }
    });
    return tmp;
  }

  /// launch to an URL
  static void launch(BuildContext context, String url) async {
    if (!url.contains('#')) {
      if (url == '/')
        Navigator.of(context).pushNamed('/');
      else {
        url = correctLink(url);
        if (url.contains('tuyensinh.ctu.edu.vn') &&
            url.substring(url.length - 3) != 'pdf' &&
            url.substring(url.length - 3) != 'jpg')
          Navigator.of(context).push(new MaterialPageRoute(
              builder: (BuildContext context) => Loading(url: url)));
        else if (await browser.canLaunch(url)) {
          await browser.launch(url, forceWebView: false);
        } else {
          pushNotification(context, 'Could not launch $url', '');
        }
      }
    }
  }

  /// correct a link to http standard
  static String correctLink(String url) {
    if (url.length > 4 && url.substring(0, 4) != 'http') return homeLink + url;
    return url;
  }
}
