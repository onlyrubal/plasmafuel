import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/primary_filter.dart';
import '../widgets/primary_outline_filter.dart';
import '../providers/donor_info.dart';
import '../screens/filter_screen.dart';
import '../widgets/donor_item.dart';

class SearchScreen extends StatefulWidget {
  static const routeName = '/search_page';
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  bool _checkDidChangeDependenciesRan = true;
  List<dynamic> donorCities;

  @override
  void didChangeDependencies() {
    if (_checkDidChangeDependenciesRan) {
      donorCities = Provider.of<Donors>(context).cities;
      print(donorCities.length);
    }
    _checkDidChangeDependenciesRan = false;
    super.didChangeDependencies();
  }

  void _addNewFilter(BuildContext context, String filterType) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30.0),
          topRight: Radius.circular(30.0),
        ),
      ),
      builder: (_) {
        return SingleChildScrollView(
          child: Container(
            color: Colors.transparent,
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: FilterScreen(donorCities),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final _filteredDonorItems = Provider.of<Donors>(context).filteredItems();
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  'Filter By :',
                  style: Theme.of(context)
                      .textTheme
                      .bodyText2
                      .copyWith(fontWeight: FontWeight.bold),
                ),
                GestureDetector(
                  onTap: () {
                    _addNewFilter(context, 'city');
                  },
                  child: Provider.of<Donors>(context).isCityFilterSelected
                      ? PrimaryFilter(btnText: 'City')
                      : PrimaryOutlineFilter(btnText: 'City'),
                ),
              ],
            ),
            SizedBox(height: 20),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemBuilder: (ctx, index) => ChangeNotifierProvider.value(
                    value: _filteredDonorItems[index],
                    child: DonorItem(),
                  ),
                  itemCount: _filteredDonorItems.length,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
