import 'package:flutter/cupertino.dart';
import 'package:password_storage_app/models/hosting.dart';

import '../app_data.dart';

class HostingRepository with ChangeNotifier{
  final String _token;
  final String _userId;
  List<Hosting> _hostings = HOSTINGS;

  HostingRepository(this._token, this._userId);

  Future<void> fetchAndSetHostings() async {

    _hostings = HOSTINGS;
    notifyListeners();
  }

  List<Hosting> get hostings {
    return [..._hostings];
  }
}
