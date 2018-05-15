import 'package:flutter/material.dart';


class ListItem extends StatelessWidget {


  final String text;

  const ListItem({Key key, this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new ListTile(
      title: new Text(text),
    );
  }
}
