import 'package:html/parser.dart' show parse;
import 'package:http/http.dart' as http;
import 'package:html/dom.dart';

Map<String, String> getDocument(String html){
  final document = parse(html);
  Map _list = new Map<String, String>();

  document.body.getElementsByTagName('a').forEach((Element) {
    //if (Element.attributes['href'] != null) {
      _list[Element.text] = Element.attributes['href'];  
    //}
    
  });

  return _list;
}