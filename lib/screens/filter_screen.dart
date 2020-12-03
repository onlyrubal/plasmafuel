import 'package:flutter/material.dart';
import '../providers/donor_info.dart';
import 'package:provider/provider.dart';

class FilterScreen extends StatefulWidget {
  final List<dynamic> filterValues;
  FilterScreen(this.filterValues);
  @override
  _FilterScreenState createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  // Form Key
  final _formKey = GlobalKey<FormState>();
  var _cityFiltered = null;

  Future<void> _saveFilterForm() async {
    final _isFormValid = _formKey.currentState.validate();

    if (!_isFormValid) return;

    _formKey.currentState.save();

    Provider.of<Donors>(context, listen: false).applyCityFilter(_cityFiltered);
    // print(Provider.of<Donors>(context, listen: false).isCityFilterSelected);
    // print(_cityFiltered);
    Navigator.of(context).pop();
  }

  InputDecoration textDecoration(String labelText) {
    return InputDecoration(
      contentPadding: EdgeInsets.all(10),
      border: OutlineInputBorder(
        borderSide: BorderSide(
          color: Theme.of(context).buttonColor,
        ),
        borderRadius: BorderRadius.all(
          Radius.circular(10),
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: Theme.of(context).accentColor,
        ),
      ),
      labelText: labelText,
      labelStyle: Theme.of(context).textTheme.bodyText2.copyWith(fontSize: 18),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      width: double.infinity,
      child: Card(
        color: Colors.transparent,
        elevation: 0,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Form(
              key: _formKey,
              child: ListView(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: 40),
                children: [
                  SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: DropdownButtonFormField(
                      decoration: textDecoration('Select City'),
                      items: widget.filterValues.map(
                        (selectedCity) {
                          return DropdownMenuItem(
                            child: Text(
                              selectedCity,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText2
                                  .copyWith(fontSize: 18),
                            ),
                            value: selectedCity,
                          );
                        },
                      ).toList(),
                      onSaved: (newValue) {
                        _cityFiltered = newValue;
                      },
                      onChanged: (_) {},
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      FlatButton(
                        child: Text(
                          'Reset Filters',
                          style: TextStyle(
                            color: Theme.of(context).accentColor,
                            fontSize: 18,
                          ),
                        ),
                        onPressed: () {
                          Provider.of<Donors>(context, listen: false)
                              .clearCityFilter();
                          Navigator.pop(context);
                          print(Provider.of<Donors>(context, listen: false)
                              .isCityFilterSelected);
                        },
                      ),
                      FlatButton(
                        child: Text(
                          'Apply',
                          style: TextStyle(
                            color: Theme.of(context).accentColor,
                            fontSize: 18,
                          ),
                        ),
                        onPressed: () => _saveFilterForm(),
                      )
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
