import 'package:flutter/material.dart';
import 'package:flutter_bottom_aierke/bloc/marsh_bloc.dart';
import 'package:flutter_bottom_aierke/bloc/marsh_event.dart';
import 'package:flutter_bottom_aierke/bloc/marsh_state.dart';
import 'package:lottie/lottie.dart';

void main() => runApp(MaterialApp(home: CustomBottomBar()));

class CustomBottomBar extends StatefulWidget {
  @override
  _CustomBottomBarState createState() => _CustomBottomBarState();
}

class _CustomBottomBarState extends State<CustomBottomBar> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    LottiePage(),
    PostsPage(),
    Center(child: Text('Работа')),
    Center(child: Text('Музыка')),
  ];

  Color _getIconColor(int index) {
    return _currentIndex == index ? Colors.blue : Colors.grey;
  }

  double _getIconSize(int index) {
    return _currentIndex == index ? 30 : 25;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        elevation: 10,
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Padding(
              padding: EdgeInsets.only(bottom: 5),
              child: Icon(Icons.person,
                  color: _getIconColor(0), size: _getIconSize(0)),
            ),
            label: 'Акцент',
          ),
          BottomNavigationBarItem(
            icon: Padding(
              padding: EdgeInsets.only(bottom: 5),
              child: Icon(Icons.home,
                  color: _getIconColor(1), size: _getIconSize(1)),
            ),
            label: 'Дом',
          ),
          BottomNavigationBarItem(
            icon: Padding(
              padding: EdgeInsets.only(bottom: 5),
              child: Icon(Icons.work,
                  color: _getIconColor(2), size: _getIconSize(2)),
            ),
            label: 'Работа',
          ),
          BottomNavigationBarItem(
            icon: Padding(
              padding: EdgeInsets.only(bottom: 5),
              child: Icon(Icons.music_note,
                  color: _getIconColor(3), size: _getIconSize(3)),
            ),
            label: 'Музыка',
          ),
        ],
      ),
    );
  }
}

class PostsPage extends StatefulWidget {
  @override
  _PostsPageState createState() => _PostsPageState();
}

class _PostsPageState extends State<PostsPage> {
  final _bloc = MarshBloc();

  @override
  void initState() {
    super.initState();
    _bloc.eventSink.add(FetchPostsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Posts')),
      body: StreamBuilder<MarshState>(
        stream: _bloc.stateStream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: Text("Waiting for data..."));
          }

          if (snapshot.data is LoadingState) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.data is ErrorState) {
            final errorState = snapshot.data as ErrorState;
            return Center(child: Text('Error: ${errorState.message}'));
          } else if (snapshot.data is LoadedState) {
            final loadedState = snapshot.data as LoadedState;
            final posts = loadedState.posts;
            return ListView.builder(
              itemCount: posts.length,
              itemBuilder: (context, index) {
                final post = posts[index];
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    ListTile(title: Text(post.title)),
                    ListTile(title: Text('UserID: ${post.userId}')),
                    ListTile(title: Text('ID: ${post.id}')),
                    ListTile(title: Text('Body: ${post.body}')),
                    Divider(color: Colors.grey),
                  ],
                );
              },
            );
          } else {
            return Center(child: Text("Unknown state"));
          }
        },
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _bloc.dispose();
  }
}

class LottiePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Lottie.asset('assets/animate/project1.json',
                width: 200, height: 200),
            Lottie.asset('assets/animate/project2.json',
                width: 200, height: 200),
          ],
        ),
      ),
    );
  }
}
