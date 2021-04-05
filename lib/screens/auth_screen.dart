import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:password_storage_app/providers/auth.dart';
import 'package:password_storage_app/screens/splash_screen.dart';
import 'package:provider/provider.dart';
import 'package:flutter_config/flutter_config.dart';

class AuthScreen extends StatelessWidget {
  Future<void> _login(BuildContext context) async {
    await Future.delayed(Duration(seconds: 2));
    await Provider.of<Auth>(context, listen: false).signIn(
      FlutterConfig.get('firebaseLogin'),
      FlutterConfig.get('firebasePass'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      body: FutureBuilder(
          future: _login(context),
          builder: (ctx, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: Text(
                  'Trying to login...',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
                ),
              );
            }
            return SplashScreen();
          }),
    );
  }
}
