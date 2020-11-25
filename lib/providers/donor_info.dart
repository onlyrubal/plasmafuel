import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
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
  final recordProof;
  final String covidNegativeTestDate;
  final bool isAnonymous;
  final bool isAvailable;
  String userId;
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
    @required this.recordProof,
    @required this.covidNegativeTestDate,
    @required this.isAnonymous,
    this.userId = '',
    this.isBookmarked = false,
    this.isAvailable = true,
  });
}

class Donors with ChangeNotifier {
  List<Donor> _items = [
    //TEST DATA

    // Donor(
    //   donorId: '',
    //   donorName: 'Manjinder Singh',
    //   donorAddress: 'Amritsar',
    //   donorGender: 'Male',
    //   donorAge: 23,
    //   donorContactNumber: '+1-5195737187',
    //   approveStatus: 'Approved',
    //   covidSymptoms: false,
    //   recordProof: '',
    //   covidNegativeTestDate: '09-Dec-2020',
    //   isAnonymous: true,
    //   isBookmarked: true,
    // ),
    // Donor(
    //   donorId: '',
    //   donorName: 'Jasmeet Singh',
    //   donorAddress: 'Sangrur',
    //   donorGender: 'Male',
    //   donorAge: 24,
    //   donorContactNumber: '+1-5195737187',
    //   approveStatus: 'Pending',
    //   covidSymptoms: false,
    //   recordProof: '',
    //   covidNegativeTestDate: '09-Dec-2020',
    //   isAnonymous: true,
    //   isBookmarked: false,
    // ),
    // Donor(
    //   donorId: '',
    //   donorName: 'Amrinder Singh',
    //   donorAddress: 'Chandigarh',
    //   donorGender: 'Female',
    //   donorAge: 26,
    //   donorContactNumber: '+1-5195737187',
    //   approveStatus: 'Rejected',
    //   covidSymptoms: false,
    //   recordProof: '',
    //   covidNegativeTestDate: '09-Dec-2020',
    //   isAnonymous: true,
    //   isBookmarked: true,
    // ),
  ];

  Future<void> addNewDonor(Donor donor) async {
    final donorURL = 'https://plasma-fuel.firebaseio.com/donors.json';

    try {
      //POST request to add the donor

      //   final String donorId;
      // final String donorName;
      // final String donorAddress;
      // final String donorGender;
      // final int donorAge;
      // final String donorContactNumber;
      // final String approveStatus;
      // final bool covidSymptoms;
      // final String recordProof;
      // final String covidNegativeTestDate;
      // final bool isAnonymous;
      // final bool isAvailable;
      // String userId;
      // bool isBookmarked;
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

  int get bookmarkedDonorCount {
    return showBookmarkedDonors().length;
  }

  List<Donor> get items {
    return [..._items];
  }
}
