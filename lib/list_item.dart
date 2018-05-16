import 'package:flutter/material.dart';


class ListItem extends StatelessWidget {


  final String title;
  final String subtitle;

  const ListItem({Key key, this.title, this.subtitle}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new Card(
      child: new ListTile(
        title: new Text(title),
        subtitle: new Text(subtitle, overflow: TextOverflow.ellipsis, maxLines: 2,),
      ),
    );
   /* return new ListTile(
      title: new Text(title),
      subtitle: new Text(subtitle),
    );*/
  }
}
