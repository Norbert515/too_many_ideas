import 'dart:async';

import 'package:find_your_idea/filter_input.dart';
import 'package:find_your_idea/list_item.dart';
import 'package:find_your_idea/model/post.dart';
import 'package:find_your_idea/repository.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

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



  FocusNode focusNode;

  ScrollController controller = new ScrollController();

  final double loadMoreThreshold = 200.0;

  bool isLoading = false;

  Repository repository = new Repository();

  List<FilterItem> filter = [];


  @override
  void initState() {
    super.initState();
    focusNode = new FocusNode();

    repository.load();


    controller.addListener(() {
      if(controller.offset > controller.position.maxScrollExtent - loadMoreThreshold) {
        _loadMore();
      }
    });
  }




  void _loadMore() {
    if(!isLoading) {
      setState(() {
        isLoading = true;
      });
      repository.load().then((_) {
        setState(() {
          isLoading = false;
        });
      });
    }
  }


  @override
  void dispose() {
    focusNode.dispose();
    repository.dispose();
    super.dispose();
  }


  void _onFilterSettingsChanged(List<FilterItem> items) {
    setState(() {
      filter = items;
    });
  }

  bool _shouldKeepItem(RedditPost post) {
    if(filter.isEmpty) return true;
    String regexString = filter.map((filterItem)=> filterItem.text).join("|");
    if(post.title.contains(new RegExp(regexString)) || post.selftext.contains(new RegExp(regexString))) {
      return true;
    }
    return false;
  }

  List<RedditPost> _filter(List<RedditPost> posts) {
    return posts.where(_shouldKeepItem).toList();
  }
  List<RedditPost> _filter2(List<RedditPost> posts) {
    List<RedditPost> result = [];
    for(RedditPost post in posts) {
      if(_shouldKeepItem(post)) {
        result.add(post);
      }
    }
    return result;
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
            child: new FilterInput(
              onFilterSettingsChanged: _onFilterSettingsChanged,
            ),
          ),
          new StreamBuilder<List<RedditPost>>(
            stream: repository.getPostStream(),
          //  stream: repository.getPostStream().map(_filter2),
            builder: (BuildContext context, AsyncSnapshot<List<RedditPost>> snapshot) {
              List<RedditPost> items = _filter2(snapshot.data ?? const []);
              return new SliverList(delegate: new SliverChildBuilderDelegate((BuildContext context, int index) {

                return new InkWell(
                  onTap: () {
                    Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context) {
                      return new ListItemPage(
                        title: items[index].title,
                        subtitle: items[index].selftext,
                        source: items[index].permalink,
                      );
                    }));
                  },
                    child: new ListItem(title: items[index].title, subtitle: items[index].selftext,)
                );

              }, childCount: items != null ? items.length : 0));
            },
          ),
          new SliverToBoxAdapter(
            child: isLoading? new Center(child: new CircularProgressIndicator()) :new MaterialButton(child: new Text("load more"), onPressed: _loadMore,),
          )
        ],
        controller: controller,
      ),
    );
  }
}


