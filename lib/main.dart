import 'package:find_your_idea/list_item.dart';
import 'package:find_your_idea/model/post.dart';
import 'package:find_your_idea/repository.dart';
import 'package:flutter/material.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {


  List<RedditPost> items = [];

  FocusNode focusNode;


  @override
  void initState() {
    super.initState();
    new RedditDataSource().getRecentPostsFrom("ProgrammerHumor").then((items)=> setState((){this.items = items;}));
    focusNode = new FocusNode();
  }


  @override
  void dispose() {
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title),
      ),
      body: new CustomScrollView(
        slivers: <Widget>[
          //TODO maybe sliver app bar? No but overscroll!!
          new SliverToBoxAdapter(
            child: new FilterInput(),
          ),
          new SliverList(delegate: new SliverChildBuilderDelegate((BuildContext context, int index) {
            return new ListItem(text: items[index].title,);
          }, childCount: items.length))
        ],
      ),
    );
  }
}


class FilterInput extends StatefulWidget {
  @override
  _FilterInputState createState() => new _FilterInputState();
}

class _FilterInputState extends State<FilterInput> {
  @override
  Widget build(BuildContext context) {
    return new Card(
      child: new Wrap(
        children: <Widget>[
          new SizedBox(
            child: new TextField(),
            width: 100.0,
          ),
          new Chip(label: new Text("hi"), onDeleted: (){}, ),
        ],
      ),
    );
  }
}
