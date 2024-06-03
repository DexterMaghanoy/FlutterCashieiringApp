import 'package:flutter/material.dart';
import 'package:flutterproject/home.dart';
import 'package:flutterproject/products.dart';
import 'package:flutterproject/sales.dart';
import 'package:flutterproject/user.dart';

import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'POS',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _currentIndex = _tabController.index;
      });
    });
  } 

  Future<void> _onRefresh() async {
    // Add your refresh logic here
    // This is where you can update data or perform any async operation
    await Future.delayed(Duration(seconds: 2));
    // After the refresh is complete, you can setState to update the UI
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Cashiering System')),
        backgroundColor: Colors.deepOrangeAccent,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text('Settings'),
                    content: Text('This is the settings dialog.'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(); // Close the dialog
                        },
                        child: Text('Close'),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
        leading: Builder(
          builder: (BuildContext context) { 
            return IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
              tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
            );
          },
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        child: TabBarView(
          controller: _tabController,
          children: [
            // Your Home widget content here
            Home(),
            shop(),
            SalesPage(),
            ScanCodePage(),

            // Add the other tabs as needed
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'User: ',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              title: Text('Account'),
              onTap: () {
                // Add functionality for Option 1
                Navigator.pop(context); // Close the drawer
              },
            ),
            ListTile(
              title: Text('Settings'),
              onTap: () {
                // Add functionality for Option 2
                Navigator.pop(context); // Close the drawer
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return SalomonBottomBar(
      currentIndex: _currentIndex,
      onTap: (index) {
        _tabController.animateTo(index);
      },
      items: [
        SalomonBottomBarItem(
          icon: Icon(Icons.home_filled),
          title: Text('Home'),
          selectedColor: Colors.deepOrange,
        ),

        SalomonBottomBarItem(
          icon: Icon(Icons.add_box),
          title: Text('Product'),
          selectedColor: Colors.deepOrange,
        ),

        SalomonBottomBarItem(
          icon: Icon(Icons.add_shopping_cart_sharp),
          title: Text('Sales'),
          selectedColor: Colors.deepOrange,
        ),

        SalomonBottomBarItem(
          icon: Icon(Icons.person_2_rounded),
          title: Text('Profile'),
          selectedColor: Colors.deepOrange,
        ),
        // Add the other bottom bar items as needed
      ],
      backgroundColor: Colors.blue[300],
      unselectedItemColor: Colors.black,
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}
