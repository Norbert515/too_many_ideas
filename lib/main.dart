import 'package:find_your_idea/filter_input.dart';
import 'package:find_your_idea/list_item.dart';
import 'package:find_your_idea/model/post.dart';
import 'package:find_your_idea/repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(
        primarySwatch: Colors.indigo,
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

  bool showFastScrollUp = false;

  int allItemsCount = 0;
  int filteredItemsCount = 0;


  double bufferPosition = 0.0;
  bool scrollsUp = false;

  double showFastScrollThreshold = 200.0;

  double firstActivateThreshold = 1000.0;
  @override
  void initState() {
    super.initState();
    focusNode = new FocusNode();

    repository.load();


    controller.addListener(() {
      if(controller.offset > controller.position.maxScrollExtent - loadMoreThreshold) {
        _loadMore();
      }

      if(controller.position.userScrollDirection == ScrollDirection.forward && controller.offset > firstActivateThreshold) {
        //When switching from scrolling down to scrolling up
        if(!scrollsUp) {
          bufferPosition = controller.offset;
        }
        if(bufferPosition - controller.offset > showFastScrollThreshold) {
          setState(() {
            showFastScrollUp = true;
          });
        }
        scrollsUp = true;

      } else {
        scrollsUp = false;
        setState(() {
          showFastScrollUp = false;
        });
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
    controller.dispose();
    super.dispose();
  }

  
  
  void _scrollUp() {
    controller.animateTo(0.0, duration: const Duration(milliseconds: 900), curve: Curves.decelerate);
    setState(() {
      showFastScrollUp = false;
    });
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
    return new StreamBuilder<List<RedditPost>>(
      stream: repository.getPostStream(),
      builder: (BuildContext context, AsyncSnapshot<List<RedditPost>> snapshot) {
        allItemsCount = snapshot.data?.length ?? 0;
        List<RedditPost> items = _filter2(snapshot.data ?? const []);
        filteredItemsCount = items.length;
        return new Scaffold(
          appBar: new AppBar(
            title: new Text(widget.title),
            bottom: new PreferredSize(
                child: new Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14.0),
                  child: new Align(
                      alignment: Alignment.centerLeft,
                      child: new Text("$allItemsCount/$filteredItemsCount", style: new TextStyle(color: Colors.white),)
                  ),
                ),
                preferredSize: const Size.fromHeight(5.0)
            )
          ),
          body: new Container(
            color: const Color(0xffF0F0F0),
            child: new FastScrollTop(
              visible: showFastScrollUp,
              onClick: _scrollUp,
              child: new CustomScrollView(
                slivers: <Widget>[
                  new SliverToBoxAdapter(
                    child: new FilterInput(
                      onFilterSettingsChanged: _onFilterSettingsChanged,
                    ),
                  ),
                  new SliverList(delegate: new SliverChildBuilderDelegate((BuildContext context, int index) {
                    return new ListItem(title: items[index].title, subtitle: items[index].selftext, onTap: () {
                      Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context) {
                        return new ListItemPage(
                          title: items[index].title,
                          subtitle: items[index].selftext,
                          source: items[index].permalink,
                        );
                      }));
                    },);

                  }, childCount: items != null ? items.length : 0)),
                  new SliverToBoxAdapter(
                    child: isLoading? new Center(child: new CircularProgressIndicator()) :new MaterialButton(child: new Text("load more"), onPressed: _loadMore,),
                  )
                ],
                controller: controller,
              ),
            ),
          ),
        );
      },
    );
  }
}


class FastScrollTop extends StatefulWidget {

  final bool visible;

  final Widget child;

  final VoidCallback onClick;

  const FastScrollTop({Key key, this.visible, this.child, this.onClick}) : super(key: key);

  @override
  _FastScrollTOpState createState() => new _FastScrollTOpState();
}

class _FastScrollTOpState extends State<FastScrollTop> {

  @override
  Widget build(BuildContext context) {
    Color color = Theme.of(context).accentColor;
    return new Stack(
      children: <Widget>[
        widget.child,
        widget.visible ? new Positioned(
            top: 10.0,
            bottom:  null,
            left: 0.0,
            right: 0.0,
            child: new Center(
              child: new MaterialButton(
                onPressed: widget.onClick,
                color: color,
                child: new Text("Scroll up"),
              ),
            )
        ): new SizedBox()
      ],
    );
  }
}
