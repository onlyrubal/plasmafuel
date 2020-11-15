import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  static const routeName = '/search_page';
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Column(
        children: [
          SizedBox(height: 10),
          GestureDetector(
            onTap: () {
              showSearch(context: context, delegate: DataSearch());
            },
            child: Card(
              elevation: 4,
              margin: EdgeInsets.symmetric(horizontal: 20),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                  color: Color(0xFFEAF0F1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 50),
                      child: Text(
                        'Search by City',
                        style: TextStyle(
                          color: Colors.black54,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(right: 20),
                      child: Icon(Icons.search_sharp),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      )),
    );
  }
}

class DataSearch extends SearchDelegate<String> {
  final List<String> cities = [
    'New Delhi',
    'Amritsar',
    'Patiala',
    'Chandigarh',
  ];

  final List<String> recentCities = [
    'New Delhi',
    'Amritsar',
    'Patiala',
    'Chandigarh',
  ];

  @override
  List<Widget> buildActions(BuildContext context) {
    // actions for app bar

    return [
      Padding(
        padding: const EdgeInsets.only(right: 20.0),
        child: IconButton(
            icon: Icon(Icons.clear_sharp),
            onPressed: () {
              query = '';
            }),
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    //Leading icon on the left of the app bar.
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // show results based on the input.
    return Container(
      height: 100,
      width: 100,
      child: Card(
        color: Colors.blueAccent,
        child: Center(
          child: Text(query),
        ),
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // show suggestions when someone searches for something.
    final suggestionList = query.isEmpty
        ? recentCities
        : cities
            .where((p) => p.toLowerCase().startsWith(query.toLowerCase()))
            .toList();

    return ListView.builder(
      itemBuilder: (context, index) => Column(
        children: [
          ListTile(
            onTap: () {
              // Show the Results
              showResults(context);
            },
            leading: Icon(
              Icons.location_city,
              color: Theme.of(context).accentColor,
            ),
            title: RichText(
              text: TextSpan(
                  text: suggestionList[index].substring(0, query.length),
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                  children: [
                    TextSpan(
                      text: suggestionList[index].substring(query.length),
                      style: TextStyle(color: Colors.black38),
                    ),
                  ]),
            ),
          ),
          Divider(),
        ],
      ),
      itemCount: suggestionList.length,
    );
  }
}
