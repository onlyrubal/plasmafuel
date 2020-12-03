import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/http_exception.dart';

class Auth with ChangeNotifier {
  String _token;
  DateTime _expiryDate;
  String _userId;
  Timer _authTimer;

  String get token {
    if (_token != null &&
        _expiryDate != null &&
        _expiryDate.isAfter(DateTime.now())) {
      return _token;
    }
    // Otherwise return null instead of token
    return null;
  }

  String get userId {
    return _userId;
  }

  bool get isAuth {
    // If user has the token and it is not expired
    return token != null;
  }

  Future<void> _authenticate(
      String email, String password, String urlSegment) async {
    final url =
        'https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=AIzaSyCdmTSZVR4qNRLy1jC8mos8i00JoknOfr0';

    try {
      final response = await http.post(
        url,
        body: json.encode(
          {
            'email': email,
            'password': password,
            'returnSecureToken': true,
          },
        ),
      );

      final responseData = json.decode(response.body);
      // It means if it is not null, so there is an error key inside the decoded json data.

      if (responseData['error'] != null) {
        throw HttpException(errorMessage: responseData['error']['message']);
      }

      _token = responseData['idToken'];
      _expiryDate = DateTime.now().add(Duration(
        seconds: int.parse(responseData['expiresIn']),
      ));
      _userId = responseData['localId'];
      // Notifying Listeners to trigger the Consumer in main.dart
      _autoLogout();
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> signUp(String email, String password) async {
    return _authenticate(email, password, 'signUp');
  }

  Future<void> userLogin(String email, String password) async {
    return _authenticate(email, password, 'signInWithPassword');
  }

  void signOut() {
    _token = null;
    _expiryDate = null;
    _userId = null;

    if (_authTimer != null) {
      _authTimer.cancel();
      _authTimer = null;
    }
    notifyListeners();
  }

  void _autoLogout() {
    if (_authTimer != null) {
      _authTimer.cancel();
    }
    final timeToExpiry = _expiryDate.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(Duration(seconds: timeToExpiry), signOut);
  }
}
