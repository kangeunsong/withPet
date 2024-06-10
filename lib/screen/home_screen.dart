import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:with_pet/screen/service/databaseSvc.dart';
import '../const/tabs.dart';
import 'homePage/google_map_page.dart';
import 'homePage/calendar_page.dart';
import 'homePage/pagehome.dart';
import 'homePage/rank.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'homePage/pagehome.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  late PageController _pageController;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _getUserUID();
    _pageController = PageController(initialPage: _selectedIndex);
  }

  final _authetication = FirebaseAuth.instance;
  String userkey = 'null';
  void _getUserUID() {
    final User? user = _authetication.currentUser;
    setState(() {
      if (user != null) {
        userkey = user.uid;
      } else {
        userkey = 'No user signed in';
      }
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    _pageController.jumpToPage(index);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Container(
            height: AppBar().preferredSize.height,
            child: Image.asset('asset/img/logo.png')),
        centerTitle: true,
        leading: Builder(
          builder: (context) {
            return IconButton(
              icon: Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
        actions: [
          IconButton(icon: Icon(Icons.person_rounded), onPressed: null)
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            ListTile(
              leading: Icon(Icons.home),
              iconColor: Colors.lightBlueAccent,
              focusColor: Colors.lightBlueAccent,
              title: Text('홈'),
              onTap: () {
                Navigator.of(context).pop();
              },
              trailing: Icon(Icons.navigate_next),
            ),
            ListTile(
              leading: Icon(Icons.shopping_cart_rounded),
              iconColor: Colors.lightBlueAccent,
              focusColor: Colors.lightBlueAccent,
              title: Text('산책 기록'),
              onTap: () {
                Navigator.of(context).pop(); // Close the drawer
                _onItemTapped(1); // Navigate to the second page
              },
              trailing: Icon(Icons.navigate_next),
            ),
            ListTile(
              leading: Icon(Icons.mark_as_unread_sharp),
              iconColor: Colors.lightBlueAccent,
              focusColor: Colors.lightBlueAccent,
              title: Text('랭킹'),
              onTap: () {
                Navigator.of(context).pop(); // Close the drawer
                _onItemTapped(2); // Navigate to the second page
              },
              trailing: Icon(Icons.navigate_next),
            ),
            ListTile(
              leading: Icon(Icons.restore_from_trash),
              iconColor: Colors.lightBlueAccent,
              focusColor: Colors.lightBlueAccent,
              title: Text('캘린더'),
              onTap: () {
                Navigator.of(context).pop(); // Close the drawer
                _onItemTapped(3); // Navigate to the second page
              },
              trailing: Icon(Icons.navigate_next),
            ),
            ListTile(
              leading: Icon(Icons.settings),
              iconColor: Colors.lightBlueAccent,
              focusColor: Colors.lightBlueAccent,
              title: Text('설정'),
              onTap: () {},
              trailing: Icon(Icons.navigate_next),
            ),
            ListTile(
              leading: Icon(Icons.settings),
              iconColor: Colors.lightBlueAccent,
              focusColor: Colors.lightBlueAccent,
              title: Text('로그아웃'),
              onTap: () {
                _authetication.signOut();
                Navigator.of(context).pop();
                Navigator.of(context).pop(); // 임시, 나중에 로그인 화면으로 가는 코드로 수정
              },
              trailing: Icon(Icons.navigate_next),
            ),
            ListTile(
              leading: Icon(Icons.settings),
              iconColor: Colors.lightBlueAccent,
              focusColor: Colors.lightBlueAccent,
              title: Text('회원탈퇴'),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text("회원 탈퇴 하시겠습니까?"),
                      actions: [
                        TextButton(
                          onPressed: () {
                            // DatabaseSvc databaseSvc = DatabaseSvc();
                            DatabaseSvc().deleteDB(userkey, _authetication);
                            Navigator.of(context).pop();
                            Navigator.of(context).pop();
                            Navigator.of(context).pop(); // 임시, 나중에 로그인 화면으로 가는 코드로 수정
                          },
                          child: Text('OK'),
                        ),
                      ],
                    );
                  },
                );
              },
              trailing: Icon(Icons.navigate_next),
            ),
          ],
        ),
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        children: [
          // 각 탭에 해당하는 페이지 위젯을 여기에 추가합니다.
          PageHome(temp: userkey),

          GoogleMapPage(),

          ///PageMap(),
          Page3(),
          // Page4(),
          CalendarPage(),
          // TABS의 길이에 맞게 페이지를 추가하세요.
        ],
      ),
      bottomNavigationBar: ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30.0),
          topRight: Radius.circular(30.0),
        ),
        child: BottomNavigationBar(
          selectedItemColor: Colors.black,
          unselectedItemColor: Colors.grey,
          showSelectedLabels: true,
          showUnselectedLabels: true,
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          type: BottomNavigationBarType.fixed,
          items: TABS
              .map(
                (e) => BottomNavigationBarItem(
                  icon: Icon(e.icon),
                  label: e.label,
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}
