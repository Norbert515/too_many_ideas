import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share/share.dart';

class ListItem extends StatelessWidget {


  final String title;
  final String subtitle;

  final VoidCallback onTap;

  const ListItem({Key key, this.title, this.subtitle, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextStyle titleTextStyle = new TextStyle(
      fontSize: 13.0,
      fontWeight: FontWeight.bold,

    );

    TextStyle subtitleTextStyle = new TextStyle(
      fontSize: 10.0,
      fontWeight: FontWeight.w300

    );

    return new Card(
      margin: const EdgeInsets.symmetric(vertical: 4.0),
      shape: new RoundedRectangleBorder(),
      elevation: 0.5,
      child: new InkWell(
        onTap: onTap,
        child: new Padding(
          padding: const EdgeInsets.all(8.0),
          child: new Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              new Text(title, style: titleTextStyle,),
              subtitle.isNotEmpty? new Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: new Text(subtitle, style: subtitleTextStyle, overflow: TextOverflow.ellipsis, maxLines: 3,),
              )
                  : new SizedBox()
            ],
          ),
        ),
      ),
 /*     child: new ListTile(
        title: new Text(title),
        subtitle: new Text(subtitle, overflow: TextOverflow.ellipsis, maxLines: 2,),
      ),*/
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
    TextStyle titleTextStyle = const TextStyle(
      fontSize: 20.0,
      fontWeight: FontWeight.bold,

    );
    TextStyle subtitleTextStyle = const TextStyle(
        fontSize: 10.0,
        fontWeight: FontWeight.w300

    );

    Color buttonColor = Theme.of(context).accentColor;

    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Item"),
      ),
      body: new ListView(
        padding: const EdgeInsets.all(12.0),
        children: <Widget>[
          new Text(title, style: titleTextStyle,),
          new Divider(),
          new MarkdownBody(data: subtitle, onTapLink: _onLinkTapped,),
          new Divider(),
        //  new MarkdownBody(data: "[source](https://www.reddit.com$source)", onTapLink: _onLinkTapped,),
          new Row(
            children: <Widget>[
              new Expanded(
                  flex: 1,
                  child: new Padding(
                    padding: const EdgeInsets.only(right: 4.0),
                    child: new MaterialButton(child: new Text("Source"), onPressed: (){
                      _onLinkTapped("https://www.reddit.com$source");
                    }, color: buttonColor,),
                  )
              ),
              new Expanded(
                  flex: 3,
                  child: new MaterialButton(child: new Text("Share Idea"), onPressed: _share, color: buttonColor,)
              ),
            ],
          ),
        //  new MaterialButton(child: new Text("Share Idea"), onPressed: _share, color: Colors.blue,)
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
