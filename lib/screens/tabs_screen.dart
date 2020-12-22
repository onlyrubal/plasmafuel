import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../screens/favorite_screen.dart';
import 'home_screen.dart';
import 'search_screen.dart';
import 'settings_screen.dart';
import '../providers/donor_info.dart';
import '../widgets/badge.dart';

class TabsScreen extends StatefulWidget {
  static const routeName = '/tabs_screen';
  @override
  _TabsScreenState createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {
  // List of Pages saved in the seperate variable.
  List<Object> _pages;

  int _selectedPageIndex = 0;
  bool _checkDidChangeDependenciesRan = true;
  // Fetching the Donors from the Database
  @override
  void didChangeDependencies() async {
    final donorInfoData = Provider.of<Donors>(context);
    if (_checkDidChangeDependenciesRan) {
      try {
        await donorInfoData.fetchDonors();
      } catch (error) {
        print(error);
      }

      donorInfoData.fetchCities();
      _checkDidChangeDependenciesRan = false;
    }

    super.didChangeDependencies();
  }

  @override
  void initState() {
    _pages = [
      HomeScreen(),
      SearchScreen(),
      FavoriteScreen(),
      SettingsScreen(),
    ];
    super.initState();
  }

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedPageIndex],
      bottomNavigationBar: BottomNavigationBar(
        //Flutter automatically sends the index onto the method that we created with onTap argument.
        onTap: _selectPage,
        unselectedItemColor: Colors.white54,
        //Pass the currentIndex to tell the bottomNavigationBar which tab is selected
        currentIndex: _selectedPageIndex,
        type: BottomNavigationBarType.shifting,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Home',
            backgroundColor: Theme.of(context).primaryColor,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search_outlined),
            label: 'Search',
            backgroundColor: Theme.of(context).primaryColor,
          ),
          BottomNavigationBarItem(
            icon: Consumer<Donors>(
              builder: (context, donors, ch) => Badge(
                child: ch,
                value: donors.bookmarkedDonorCount.toString(),
              ),
              child: Icon(Icons.bookmarks_sharp),
            ),
            label: 'Saved',
            backgroundColor: Theme.of(context).primaryColor,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle_rounded),
            label: 'My Account',
            backgroundColor: Theme.of(context).primaryColor,
          ),
        ],
      ),
    );
  }
}
