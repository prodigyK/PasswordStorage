import 'package:flutter/material.dart';
import 'package:password_storage_app/screens/auth_screen.dart';
import 'package:password_storage_app/screens/emails_screen.dart';
import 'package:password_storage_app/screens/hosting_details_screen.dart';
import 'package:password_storage_app/screens/hosting_screen.dart';
import 'package:password_storage_app/screens/servers_screen.dart';
import 'package:password_storage_app/screens/splash_screen.dart';
import 'screens/categories_screen.dart';
import 'screens/settings.dart';
import 'screens/user_details_screen.dart';
import 'screens/user_screen.dart';
import 'providers/auth.dart';
import 'providers/hosting_repository.dart';
import 'providers/user_repository.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:provider/provider.dart';


var secureData = {};

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final path = await rootBundle.loadString('.env');
  var fileData = path.split('\n');
  fileData.forEach((line) {
    if (line.isEmpty) return;
    final array = line.split('=');
    secureData.putIfAbsent(array[0], () => array[1]);
  });

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (ctx) => Auth(secureData['firebaseWebKey'])),
        ChangeNotifierProxyProvider<Auth, UserRepository>(
          update: (ctx, auth, previousRepository) => UserRepository(
            auth.token,
            auth.userId,
//            previousRepository.users,
          ),
        ),
        ChangeNotifierProxyProvider<Auth, HostingRepository>(
          update: (ctx, auth, _) => HostingRepository(
            auth.token,
            auth.userId,
          ),
        ),
      ],
      child: Consumer<Auth>(
        builder: (ctx, auth, _) => MaterialApp(
          title: 'Password Storage',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.primaries[17],
            accentColor: Colors.amber,
//          canvasColor: Color.fromRGBO(255, 254, 229, 1),
            fontFamily: 'Raleway',
            textTheme: ThemeData.light().textTheme.copyWith(
                  bodyText1: TextStyle(
                    color: Color.fromRGBO(20, 51, 51, 1),
                  ),
                  bodyText2: TextStyle(
                    color: Color.fromRGBO(20, 51, 51, 1),
                  ),
                  headline6: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'RobotoCondensed',
                  ),
                ),
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          home: auth.isAuth
              ? CategoriesScreen()
              : FutureBuilder(
                  future: auth.tryAutoLogin(),
                  builder: (ctx, snapshot) {
                    return snapshot.connectionState == ConnectionState.waiting ? SplashScreen() : AuthScreen();
                  }),
          routes: {
            UserScreen.routeName: (ctx) => UserScreen(),
            UserDetailScreen.routeName: (ctx) => UserDetailScreen(),
            EmailsScreen.routeName: (ctx) => EmailsScreen(),
            ServersScreen.routeName: (ctx) => ServersScreen(),
            HostingScreen.routeName: (ctx) => HostingScreen(),
            SettingsScreen.routeName: (ctx) => SettingsScreen(),
            HostingDetailsScreen.routeName: (ctx) => HostingDetailsScreen(),
          },
        ),
      ),
    );
  }
}
