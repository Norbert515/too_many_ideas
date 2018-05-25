import 'dart:async';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';


class InfoPage extends StatelessWidget {


  final ValueChanged<Brightness> onThemeChanged;

  const InfoPage({Key key, this.onThemeChanged}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Info"),
      ),
      body: new Column(
        children: <Widget>[
          new ExpansionTile(
            leading: new Icon(Icons.visibility),
            title: new Text("Sources"),
            children: <Widget>[
              new ListTile(
                title: new Text("https://www.reddit.com/r/AppIdeas/"),
                onTap: ()=>_open("https://www.reddit.com/r/AppIdeas/"),
              ),
              new ListTile(
                title: new Text("https://www.reddit.com/r/Startup_Ideas/"),
                onTap: ()=>_open("https://www.reddit.com/r/Startup_Ideas/"),
              ),
              new ListTile(
                title: new Text("https://www.reddit.com/r/Lightbulb/"),
                onTap: ()=>_open("https://www.reddit.com/r/Lightbulb/"),
              ),
              new ListTile(
                title: new Text("https://www.reddit.com/r/CrazyIdeas/"),
                onTap: ()=>_open("https://www.reddit.com/r/CrazyIdeas/"),
              ),
            ],
          ),
          new Divider(),
          new ListTile(
            title: new Text("Do you like this app? Let me know and rate it on Google Play"),
            leading: new Icon(Icons.star),
            onTap: _openAppPage,
          ),
          new Divider(),
          new ListTile(
            title: new Text("App icon by https://icons8.com/"),
            onTap: _open8Icons,
            leading: new Icon(Icons.search),
          ),
          new Divider(),
          new ListTile(
            title: new Text("Change Theme"),
            onTap: (){
              _askedToLead(context);
            },
            leading: new Icon(Icons.looks),
          ),
        ],
      ),
    );
  }


  void _openAppPage() {
    _open("https://play.google.com/store/apps/details?id=com.norbertkozsir.toomanyideas");
  }

  void _open8Icons() {
    _open("https://icons8.com");
  }



  Future<Null> _askedToLead(BuildContext context) async {
    await showDialog<Brightness>(context: context, builder: (BuildContext context) {
      return new SimpleDialog(
        title: const Text('Select Theme'),
        children: <Widget>[
          new SimpleDialogOption(
            onPressed: () { Navigator.pop(context, Brightness.dark); },
            child: new RadioListTile<Brightness>(
              value: Brightness.light,
              groupValue: Theme.of(context).brightness,
              onChanged: (value){
                onThemeChanged(value);
              },
              title: new Text("Light"),
            ),
          ),
          new SimpleDialogOption(
            onPressed: () { Navigator.pop(context, Brightness.dark); },
            child: new RadioListTile<Brightness>(
              value: Brightness.dark,
              groupValue: Theme.of(context).brightness,
              onChanged: (value){
                onThemeChanged(value);
              },
              title: new Text("Spooky  👻"),
            ),
          ),
        ],
      );
      });
  }



  void _open(String url) async{
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
