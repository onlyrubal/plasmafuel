import 'package:flutter/material.dart';
import 'package:plasma_fuel/widgets/donor_item.dart';
import 'package:provider/provider.dart';
import '../providers/donor_info.dart';

enum FilterOptions {
  All,
  Saved,
}

class FavoriteScreen extends StatefulWidget {
  static const routeName = '/bookmark_screen';
  @override
  _FavoriteScreenState createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  bool _showBookmarkedOnly = true;

  @override
  Widget build(BuildContext context) {
    final donorInfoData = Provider.of<Donors>(context);
    final donors = _showBookmarkedOnly
        ? donorInfoData.showBookmarkedDonors()
        : donorInfoData.items;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(40.0),
        child: AppBar(
          title: Container(
            padding: EdgeInsets.only(bottom: 10),
            child: Text(
              'Saved',
              style: Theme.of(context).textTheme.bodyText1,
            ),
          ),
          backgroundColor: Color(0xff4C4B4B),
          elevation: 0,
          iconTheme: new IconThemeData(
            color: Colors.white,
          ),
          actions: [
            PopupMenuButton(
              padding: EdgeInsets.only(bottom: 10),
              icon: Icon(Icons.more_vert),
              onSelected: (FilterOptions selectedValue) {
                setState(() {
                  if (selectedValue == FilterOptions.Saved) {
                    _showBookmarkedOnly = true;
                  } else {
                    _showBookmarkedOnly = false;
                  }
                });
              },
              itemBuilder: (_) => [
                PopupMenuItem(
                  child: Text('Saved'),
                  value: FilterOptions.Saved,
                ),
                PopupMenuItem(
                  child: Text('All'),
                  value: FilterOptions.All,
                ),
              ],
            )
          ],
        ),
      ),
      body: SafeArea(
        child: ListView.builder(
          itemBuilder: (ctx, index) {
            return DonorItem(donors[index]);
          },
          itemCount: donors.length,
        ),
      ),
    );
  }
}
