import 'dart:async';

import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:password_storage_app/models/http_exception.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Auth with ChangeNotifier {
  late String _token;
  late DateTime _expiryDate;
  late String _userId;
  late Timer _authTimer;
  final String firebaseWebKey;

  Auth(this.firebaseWebKey);

  bool get isAuth {
    return token.isNotEmpty;
  }

  String? get userId {
    return _userId;
  }

  String get token {
    if (_expiryDate.isAfter(DateTime.now()) && _token.isNotEmpty) {
      return _token;
    }
    return '';
  }

  Future<void> _authenticate(String? email, String? password, String urlSegment) async {
    final url = Uri.https(
      'identitytoolkit.googleapis.com',
      '/v1/accounts:$urlSegment',
      {'key': firebaseWebKey},
    );
    print('inside _authenticate');
    try {
      final response = await http.post(
        url,
        body: json.encode({
          "email": email,
          "password": password,
          "returnSecureToken": true,
        }),
      );
      final responseData = json.decode(response.body);
      if (responseData['error'] != null) {
        print('throw block');
        throw HttpException(responseData['error']['message']);
      }
      _token = responseData['idToken'];
      _userId = responseData['localId'];
      _expiryDate = DateTime.now().add(Duration(
        seconds: int.parse(responseData['expiresIn']),
      ));
      _autoLogout();
      notifyListeners();
      final authData = json.encode({
        'token': _token,
        'userId': _userId,
        'expiryDate': _expiryDate.toIso8601String(),
      });
      final prefs = await SharedPreferences.getInstance();
      prefs.setString('authData', authData);
    } catch (error) {
      throw error;
    }
  }

  Future<void> signUp(String email, String password) async {
    return _authenticate(email, password, 'signUp');
  }

  Future<void> signIn(String? email, String? password) async {
    return _authenticate(email, password, 'signInWithPassword');
  }

  void logout() async {
    _token = '';
    _userId = '';
    _expiryDate = DateTime.now();
    if (!_authTimer.isActive) {
      _authTimer.cancel();
    }
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('authData');
    notifyListeners();
  }

  void _autoLogout() {
    if (!_authTimer.isActive) {
      _authTimer.cancel();
    }
    var timeToExpiry = _expiryDate.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(Duration(seconds: timeToExpiry), logout);
  }

  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('authData')) {
      return false;
    }

    final extractedAuthData = json.decode(prefs.getString('authData')!) as Map<String, Object>;
    final expiryDate = DateTime.parse(extractedAuthData['expiryDate'] as String);

    if (expiryDate.isBefore(DateTime.now())) {
      return false;
    }
    _token = extractedAuthData['token'] as String;
    _userId = extractedAuthData['userId'] as String;
    _expiryDate = expiryDate;
    notifyListeners();
    _autoLogout();
    // print(toString());
    return true;
  }

  @override
  String toString() {
    return 'Auth{_token: $_token, _expiryDate: $_expiryDate, _userId: $_userId}';
  }
}
