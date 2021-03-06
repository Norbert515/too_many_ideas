import 'package:flutter/material.dart';
import 'package:meta/meta.dart';



class FilterItem {
  final String text;



  FilterItem(this.text);
}

class FilterInput extends StatefulWidget {


  final ValueChanged<List<FilterItem>> onFilterSettingsChanged;

  const FilterInput({Key key, this.onFilterSettingsChanged}) : super(key: key);
  @override
  _FilterInputState createState() => new _FilterInputState();
}

class _FilterInputState extends State<FilterInput> {


  List<FilterItem> filterItems = [];

  TextEditingController textEditingController = new TextEditingController();


  static Iterable<Widget> putOrBetweenChips({ @required Iterable<Widget> tiles}) sync* {
    assert(tiles != null);

    final Iterator<Widget> iterator = tiles.iterator;
    final bool isNotEmpty = iterator.moveNext();

    Widget tile = iterator.current;
    while (iterator.moveNext()) {
      yield tile;
      yield new Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0),
        child: new Baseline(
          baseline: 30.0,
          baselineType: TextBaseline.ideographic,
          child: new Text("OR")
        ),
      );
      tile = iterator.current;
    }
    if (isNotEmpty)
      yield tile;
  }


  @override
  Widget build(BuildContext context) {
    return new Card(
      child: new Padding(
        padding: const EdgeInsets.all(8.0),
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
          ]..addAll(putOrBetweenChips(tiles: filterItems.map((filterItem) => new AlignedChip(
            text: filterItem.text,
            onDelete: () {
              _handleDelete(filterItem);
            },
          )))),
        ),
      ),
    );
  }



  void _handleDelete(FilterItem item) {
    setState(() {
      filterItems.remove(item);
    });
    widget.onFilterSettingsChanged(filterItems);
  }
  void _handleSubmit(String text) {
    setState(() {
      filterItems.add(new FilterItem(text));
      textEditingController.text = "";
    });
    widget.onFilterSettingsChanged(filterItems);
  }



}

class AlignedChip extends StatelessWidget {

  final String text;
  final VoidCallback onDelete;

  const AlignedChip({Key key,
    @required this.text,
    @required this.onDelete
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color color = Theme.of(context).accentColor;
    return new Baseline(
        baseline: 20.0,
        baselineType: TextBaseline.ideographic,
        child: new Chip(label: new Text(text), onDeleted: onDelete, backgroundColor: color, )
    );
  }
}