import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share/share.dart';

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

class ListItemPage extends StatelessWidget {


  final String title;
  final String subtitle;
  final String source;

  const ListItemPage({Key key, this.title, this.subtitle, this.source}) : super(key: key);


  @override
  Widget build(BuildContext context) {

    TextStyle titleStyle = const TextStyle(
      fontSize: 20.0,
    );


    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Item"),
      ),
      body: new ListView(
        padding: const EdgeInsets.all(12.0),
        children: <Widget>[
          new Text(title, style: titleStyle,),
          new Divider(),
          new MarkdownBody(data: subtitle, onTapLink: _onLinkTapped,),
          new Divider(),
          new MarkdownBody(data: "[source](https://www.reddit.com$source)", onTapLink: _onLinkTapped,),
          new MaterialButton(child: new Text("Share Idea"), onPressed: _share, color: Colors.blue,)
        ],
      ),
    );
  }


  void _share() {
    share(source);
  }

  void _onLinkTapped(String url) async{
    if (await canLaunch(url)) {
    await launch(url);
    } else {
    throw 'Could not launch $url';
    }
  }
}
