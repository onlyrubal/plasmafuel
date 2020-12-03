import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/http_exception.dart';

class Donor with ChangeNotifier {
  final String donorId;
  final String donorName;
  final String donorAddress;
  final String donorGender;
  final int donorAge;
  final String donorContactNumber;
  final String approveStatus;
  final bool covidSymptoms;
  final String bloodGroup;
  final recordProof;
  final String covidNegativeTestDate;
  final bool isAnonymous;
  final bool isAvailable;
  final String userId;
  bool isBookmarked;

  Donor({
    @required this.donorId,
    @required this.donorName,
    @required this.donorAddress,
    @required this.donorGender,
    @required this.donorAge,
    @required this.donorContactNumber,
    @required this.approveStatus,
    @required this.covidSymptoms,
    @required this.bloodGroup,
    @required this.recordProof,
    @required this.covidNegativeTestDate,
    @required this.isAnonymous,
    @required this.userId,
    this.isBookmarked = false,
    this.isAvailable = true,
  });

  Future<void> toggleBookmarkedStatus(String userId, String token) async {
    // Optimistic Updating
    final oldIsBookmarkedStatus = isBookmarked;

    isBookmarked = !isBookmarked;
    notifyListeners();

    final donorURL =
        'https://plasma-fuel.firebaseio.com/donorsBookmarked/$userId/$donorId.json?auth=$token';

    final response = await http.put(
      donorURL,
      body: json.encode(
        isBookmarked,
      ),
    );

    if (response.statusCode >= 400) {
      isBookmarked = oldIsBookmarkedStatus;
      notifyListeners();
      throw HttpException(errorMessage: response.body);
    }
  }
}

class Donors with ChangeNotifier {
  List<Donor> _items = [];

  List<String> _cities = [];

  bool _isCityFilterSelected = false;

  String _filteredCity = null;

  Future<void> addNewDonor(Donor donor) async {
    final donorURL = 'https://plasma-fuel.firebaseio.com/donors.json';

    try {
      final response = await http.post(
        donorURL,
        body: jsonEncode({
          'donorName': donor.donorName,
          'donorAddress': donor.donorAddress,
          'donorGender': donor.donorGender,
          'donorAge': donor.donorAge,
          'donorContactNumber': donor.donorContactNumber,
          'approveStatus': donor.approveStatus,
          'covidSymptoms': donor.covidSymptoms,
          'bloodGroup': donor.bloodGroup,
          'recordProof': donor.recordProof,
          'covidNegativeTestDate': donor.covidNegativeTestDate,
          'isAnonymous': donor.isAnonymous,
          'isAvailable': donor.isAvailable,
          'isBookmarked': donor.isBookmarked,
          'userId': donor.userId,
        }),
      );

      final newDonor = Donor(
        donorId: json.decode(response.body)['name'],
        donorName: donor.donorName,
        donorAddress: donor.donorAddress,
        donorGender: donor.donorGender,
        donorAge: donor.donorAge,
        donorContactNumber: donor.donorContactNumber,
        approveStatus: donor.approveStatus,
        covidSymptoms: donor.covidSymptoms,
        bloodGroup: donor.bloodGroup,
        recordProof: donor.recordProof,
        covidNegativeTestDate: donor.covidNegativeTestDate,
        isAnonymous: donor.isAnonymous,
        userId: donor.userId,
        isBookmarked: donor.isBookmarked,
        isAvailable: donor.isAvailable,
      );
      _items.add(newDonor);
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> fetchDonors() async {
    final donorURL = 'https://plasma-fuel.firebaseio.com/donors.json';
    try {
      final response = await http.get(donorURL);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;

      if (extractedData == null) return;

      //Temporary List of Donors

      final List<Donor> _loadedDonors = [];

      extractedData.forEach((donorId, donorData) {
        _loadedDonors.add(
          Donor(
            donorId: donorId,
            donorName: donorData['donorName'],
            donorAddress: donorData['donorAddress'],
            donorGender: donorData['donorGender'],
            donorAge: donorData['donorAge'],
            donorContactNumber: donorData['donorContactNumber'],
            approveStatus: donorData['approveStatus'],
            covidSymptoms: donorData['covidSymptoms'],
            bloodGroup: donorData['bloodGroup'],
            recordProof: donorData['recordProof'],
            covidNegativeTestDate: donorData['covidNegativeTestDate'],
            isAnonymous: donorData['isAnonymous'],
            userId: donorData['userId'],
            isAvailable: donorData['isAvailable'],
            isBookmarked: donorData['isBookmarked'],
          ),
        );
      });
      //Setting up the fetched list of donors to the temporary List
      _items = _loadedDonors;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  List<Donor> showBookmarkedDonors() {
    return _items.where((_donorItem) => _donorItem.isBookmarked).toList();
  }

  void fetchCities() {
    _items.forEach(
      (_donorItem) {
        _cities.add(_donorItem.donorAddress);
      },
    );
  }

  List<String> get cities {
    return [..._cities];
  }

  int get bookmarkedDonorCount {
    return showBookmarkedDonors().length;
  }

  bool get isCityFilterSelected {
    return _isCityFilterSelected;
  }

  void applyCityFilter(String city) {
    _isCityFilterSelected = (city == null) ? false : true;
    _filteredCity = city;
    notifyListeners();
  }

  void clearCityFilter() {
    _isCityFilterSelected = false;
    _filteredCity = null;

    notifyListeners();
  }

  List<Donor> get items {
    return [..._items];
  }

  String mySubmissionsCount(String authenticatedUser) {
    return _items
        .where((_donorItem) => _donorItem.userId == authenticatedUser)
        .length
        .toString();
  }

  List<Donor> mySubmissions(String authenticatedUser) {
    return _items
        .where((_donorItem) => _donorItem.userId == authenticatedUser)
        .toList();
  }

  Donor mySingleSubmission(String authenticatedUser) {
    return _items
        .firstWhere((_donorItem) => _donorItem.userId == authenticatedUser);
  }

  List<Donor> filteredItems() {
    if (_filteredCity == null)
      return _items
          .where((_donorItem) => _donorItem.approveStatus == 'Approved')
          .toList();
    else
      return _items
          .where((_donorItem) => ((_donorItem.donorAddress == _filteredCity) &&
              (_donorItem.approveStatus == 'Approved')))
          .toList();
  }
}
