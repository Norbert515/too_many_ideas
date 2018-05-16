import 'package:flutter/material.dart';
import 'package:meta/meta.dart';



class FilterItem {
  final String text;
  final Color color;

  FilterItem(this.text, this.color);
}

class FilterInput extends StatefulWidget {
  @override
  _FilterInputState createState() => new _FilterInputState();
}

class _FilterInputState extends State<FilterInput> {


  List<FilterItem> filterItems = [];

  TextEditingController textEditingController = new TextEditingController();


  @override
  Widget build(BuildContext context) {
    return new Card(
      child: new Wrap(
        children: <Widget>[
          new SizedBox(
            child: new TextField(
              controller: textEditingController,
              onSubmitted: _handleSubmit,
              decoration: new InputDecoration(hintText: "Filter"),

            ),
            width: 100.0,
          ),
        ]..addAll(filterItems.map((filterItem) => new AlignedChip(
          text: filterItem.text,
          onDelete: () {
            _handleDelete(filterItem);
          },
          color: filterItem.color,
        )).toList()),
      ),
    );
  }



  void _handleDelete(FilterItem item) {
    setState(() {
      filterItems.remove(item);
    });
  }
  void _handleSubmit(String text) {
    setState(() {
      filterItems.add(new FilterItem(text, _getNextColor()));
      textEditingController.text = "";
    });
  }


  Color _getNextColor() {
    return Colors.lightBlue;
  }
}

class AlignedChip extends StatelessWidget {

  final String text;
  final VoidCallback onDelete;
  final Color color;

  const AlignedChip({Key key,
    @required this.text,
    @required this.onDelete,
    @required this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new Baseline(
        baseline: 20.0,
        baselineType: TextBaseline.ideographic,
        child: new Chip(label: new Text(text), onDeleted: onDelete, backgroundColor: color, )
    );
  }
}