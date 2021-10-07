import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:password_storage_app/models/hosting.dart';
import 'package:http/http.dart' as http;
import 'package:password_storage_app/models/http_exception.dart';

import '../main.dart';

class HostingRepository with ChangeNotifier {
  final String _token;
  final String _userId;
  List<Hosting> _hostings = [];

  HostingRepository(this._token, this._userId);

  List<Hosting> get hostings {
    return [..._hostings];
  }

  Future<void> fetchAndSetHostings() async {
    var url = Uri.https(
      secureData['firebaseDb'],
      '/hostings.json',
      {'auth': _token},
    );
    try {
      final response = await http.get(url);
      if (response.statusCode >= 400) {
        throw HttpException('Error occured while getting items Hosting');
      }

      final fetchedData = json.decode(response.body) as Map<String, dynamic>;
      final List<Hosting> fetchedHostings = [];
      fetchedData.forEach((keyId, valueHosting) {
        Hosting hosting = Hosting.fromJson(valueHosting);
        hosting.id = keyId;
        return fetchedHostings.add(hosting);
      });
      _hostings = fetchedHostings;
      notifyListeners();

    } catch (error) {
      print(error);
      throw HttpException(error.toString());
    }
  }

  Future<void> addHosting(Hosting hosting) async {
    var url = Uri.https(
      secureData['firebaseDb'],
      '/hostings.json',
      {'auth': _token},
    );
    try {
      final response = await http.post(url, body: json.encode(hosting.toJson()));
      if (response.statusCode >= 400) {
        throw HttpException('Error occured while adding new item Hosting');
      }
      hosting.id = json.decode(response.body)['main'];
      _hostings.add(hosting);
      notifyListeners();
    } catch (error) {
      print(error);
      throw HttpException(error.toString());
    }
  }

  Future<void> updateHosting(Hosting hosting) async {
    String id = hosting.id;
    var url = Uri.https(
      secureData['firebaseDb'],
      '/hostings/$id.json',
      {'auth': _token},
    );
    try {
      final response = await http.patch(url, body: json.encode(hosting.toJson()));
      if (response.statusCode >= 400) {
        throw HttpException('Error occured while updating item Hosting');
      }
      final index = _hostings.indexWhere((hosting) => hosting.id == id);
      _hostings.removeAt(index);
      _hostings.insert(index, hosting);
      notifyListeners();
    } catch (error) {
      print(error);
      throw HttpException(error.toString());
    }
  }

  Future<void> removeHosting(Hosting hosting) async {
    String id = hosting.id;
    var url = Uri.https(
      secureData['firebaseDb'],
      '/hostings/$id.json',
      {'auth': _token},
    );
    try {
      final response = await http.delete(url, body: json.encode(hosting.toJson()));
      if (response.statusCode >= 400) {
        throw HttpException('Error occured while deleting item Hosting');
      }
      final index = _hostings.indexWhere((hosting) => hosting.id == id);
      _hostings.removeAt(index);
      notifyListeners();
    } catch (error) {
      print(error);
      throw HttpException(error.toString());
    }
  }
}
