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
              style: Theme.of(context)
                  .textTheme
                  .bodyText2
                  .copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: new IconThemeData(
            color: Colors.black,
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
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              SizedBox(height: 20),
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemBuilder: (buildContext, index) =>
                      ChangeNotifierProvider.value(
                    value: donors[index],
                    child: DonorItem(),
                  ),
                  itemCount: donors.length,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
