import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CovidTracker with ChangeNotifier {
  final String country;
  final String totalCases;
  final String todayCases;
  final String deaths;
  final String todayDeaths;
  final String recovered;
  final String active;
  final String critical;
  final String casesPerOneMillion;
  final String deathsPerOneMillion;

  CovidTracker({
    @required this.country,
    @required this.totalCases,
    @required this.todayCases,
    @required this.deaths,
    @required this.todayDeaths,
    @required this.recovered,
    @required this.active,
    @required this.critical,
    @required this.casesPerOneMillion,
    @required this.deathsPerOneMillion,
  });
}

class CovidTrackers with ChangeNotifier {
  CovidTracker _item;

  CovidTracker get item {
    return _item;
  }

  Future<void> fetchCovidStatistics() async {
    final covidTrackerURL =
        'https://coronavirus-19-api.herokuapp.com/countries/india';

    try {
      final response = await http.get(covidTrackerURL);
      // print(json.decode(response.body));
      final extractedData = json.decode(response.body) as Map<dynamic, dynamic>;

      // print(extractedData['country']);

      final _loadedData = CovidTracker(
        country: extractedData['country'].toString(),
        totalCases: extractedData['cases'].toString(),
        todayCases: extractedData['todayCases'].toString(),
        deaths: extractedData['deaths'].toString(),
        todayDeaths: extractedData['todayDeaths'].toString(),
        recovered: extractedData['recovered'].toString(),
        active: extractedData['active'].toString(),
        critical: extractedData['critical'].toString(),
        casesPerOneMillion: extractedData['casesPerOneMillion'].toString(),
        deathsPerOneMillion: extractedData['deathsPerOneMillion'].toString(),
      );

      _item = _loadedData;
      // print(_loadedData);
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }
}
