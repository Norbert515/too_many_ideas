import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';


class InfoPage extends StatelessWidget {

  static void open(BuildContext context) {
    Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context) {
      return new InfoPage();
    }), );
  }


  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(),
      body: new Column(
        children: <Widget>[
          new ListTile(
            title: new Text("Do you like this app? Let me know and rate it on Google Play"),
            leading: new Icon(Icons.stars),
            onTap: _openAppPage,
          ),
          new ListTile(
            title: new Text("App icon by https://icons8.com/"),
            onTap: _open8Icons,
            leading: new Icon(Icons.search),
          ),
        ],
      ),
    );
  }


  void _openAppPage() {
    //TODO implement
  }

  void _open8Icons() {
    _open("https://icons8.com");
  }

  void _open(String url) async{
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
