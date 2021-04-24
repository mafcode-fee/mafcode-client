import 'package:flutter/material.dart';
import 'package:mafcode/ui/screens/main/home/home_page.dart';

import 'map/map_page.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedPageIndex = 0;
  PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(
      initialPage: _selectedPageIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("MafCode - مفقود"),
        centerTitle: true,
      ),
      body: PageView(
        physics: NeverScrollableScrollPhysics(),
        controller: _pageController,
        onPageChanged: (newIndex) {
          setState(() {
            _selectedPageIndex = newIndex;
          });
        },
        children: [
          HomePage(),
          MapSample(),
          _PlaceHolder(text: "Notifications"),
          _PlaceHolder(text: "Profile"),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedPageIndex,
        onTap: (newIndex) async {
          setState(() {
            _selectedPageIndex = newIndex;
            _pageController.animateToPage(
              newIndex,
              duration: Duration(milliseconds: 500),
              curve: Curves.ease,
            );
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            label: "Map",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: "Notifications",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_rounded),
            label: "Profile",
          ),
        ],
      ),
    );
  }
}

class _PlaceHolder extends StatelessWidget {
  final String text;
  const _PlaceHolder({@required this.text, Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text("This is a placeholder page for \"$text\""),
    );
  }
}
