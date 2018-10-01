import 'package:flutter/material.dart';
import 'package:html/dom.dart' as dom;
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:html2md/html2md.dart' as html2md;

class TableBuilder extends StatelessWidget {
  final dom.Element tableElement;
  final MarkdownTapLinkCallback onTap;

  const TableBuilder({Key key, @required this.tableElement, this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> test = new List();
    List<Widget> tables = new List();
    List<TableRow> rows = new List();
    List<Widget> cells = new List();
    List<dom.Element> tableRows = tableElement.getElementsByTagName('tr');
    int rowLen = tableRows.first.getElementsByTagName('td').length;

    tableRows.forEach((row) {
      if (row.getElementsByTagName('td').length == rowLen) {
        row.getElementsByTagName('td').forEach((td) {
          cells.add(new MarkdownBody(
            data: html2md.convert(td.innerHtml),
            onTapLink: onTap,
          ));
        });
        rows.add(TableRow(children: List.generate(cells.length, (i){
          return cells[i];
        })));
        cells.clear();
      } else {
        tables.add(Table(
          border: TableBorder.all(),
          children: List.generate(rows.length, (i){
            return rows[i];
          }),
        ));
        rows.clear();
        tables.add(MarkdownBody(
          data: html2md.convert(row.innerHtml),
          onTapLink: onTap,
        ));
      }
    });

    tables.add(Table(
      border: TableBorder.all(),
      children: List.generate(rows.length, (i){
            return rows[i];
          }),
    ));
    return Column(children: tables);
  }
}
