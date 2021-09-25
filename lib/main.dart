// import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:password_storage_app/providers/mail_domain_repository.dart';
import 'package:password_storage_app/providers/mail_service_repository.dart';
import 'package:password_storage_app/providers/mailbox_repository.dart';
import 'package:password_storage_app/screens/auth_screen.dart';
import 'package:password_storage_app/screens/mailboxes/mailboxes_all_screen.dart';
import 'package:password_storage_app/screens/mailboxes/emails_by_domains_screen.dart';
import 'package:password_storage_app/screens/hostings/hosting_detail_screen.dart';
import 'package:password_storage_app/screens/hostings/hosting_screen.dart';
import 'package:password_storage_app/screens/mailboxes/emails_domains_detail_screen.dart';
import 'package:password_storage_app/screens/mailboxes/emails_domains_screen.dart';
import 'package:password_storage_app/screens/mailboxes/emails_screen.dart';
import 'package:password_storage_app/screens/mailboxes/emails_services_detail_screen.dart';
import 'package:password_storage_app/screens/mailboxes/emails_services_screen.dart';
import 'package:password_storage_app/screens/mailboxes/mailbox_detail_screen.dart';
import 'package:password_storage_app/screens/servers_screen.dart';
import 'package:password_storage_app/screens/splash_screen.dart';
import 'screens/categories_screen.dart';
import 'screens/settings.dart';
import 'screens/users/user_details_screen.dart';
import 'screens/users/user_screen.dart';
import 'providers/auth.dart';
import 'providers/hosting_repository.dart';
import 'providers/user_repository.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:provider/provider.dart';

var secureData = {};

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

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
        ChangeNotifierProvider(create: (ctx) => MailServiceRepository()),
        ChangeNotifierProvider(create: (ctx) => MailDomainRepository()),
        ChangeNotifierProvider(create: (ctx) => MailboxRepository()),
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
            ServersScreen.routeName: (ctx) => ServersScreen(),
            SettingsScreen.routeName: (ctx) => SettingsScreen(),
          },
          onGenerateRoute: (settings) {
            // print(settings.name);
            switch (settings.name) {
              case EmailsScreen.routeName:
                return PageTransition(
                  child: EmailsScreen(),
                  type: PageTransitionType.fade,
                  settings: settings,
                );
                break;
              case MailboxAllScreen.routeName:
                return PageTransition(
                  child: MailboxAllScreen(),
                  type: PageTransitionType.fade,
                  settings: settings,
                );
                break;
              case UserScreen.routeName:
                return PageTransition(
                  child: UserScreen(),
                  type: PageTransitionType.fade,
                  settings: settings,
                );
                break;
              case UserDetailScreen.routeName:
                return PageTransition(
                  child: UserDetailScreen(),
                  type: PageTransitionType.fade,
                  settings: settings,
                );
                break;
              case HostingScreen.routeName:
                return PageTransition(
                  child: HostingScreen(),
                  type: PageTransitionType.fade,
                  settings: settings,
                );
                break;
              case HostingDetailsScreen.routeName:
                return PageTransition(
                  child: HostingDetailsScreen(),
                  type: PageTransitionType.fade,
                  settings: settings,
                );
                break;
              case MailboxByDomainScreen.routeName:
                return PageTransition(
                  child: MailboxByDomainScreen(),
                  type: PageTransitionType.fade,
                  settings: settings,
                );
                break;
              case MailServicesScreen.routeName:
                return PageTransition(
                  child: MailServicesScreen(),
                  type: PageTransitionType.fade,
                  settings: settings,
                );
                break;
              case MailServicesDetailScreen.routeName:
                return PageTransition(
                  child: MailServicesDetailScreen(),
                  type: PageTransitionType.fade,
                  settings: settings,
                );
                break;
              case MailboxDomainDetailScreen.routeName:
                return PageTransition(
                  child: MailboxDomainDetailScreen(),
                  type: PageTransitionType.fade,
                  settings: settings,
                );
                break;
              case MailboxDomainsScreen.routeName:
                return PageTransition(
                  child: MailboxDomainsScreen(),
                  type: PageTransitionType.fade,
                  settings: settings,
                );
                break;
              case MailboxDetailScreen.routeName:
                return PageTransition(
                  child: MailboxDetailScreen(),
                  type: PageTransitionType.fade,
                  settings: settings,
                );
                break;
              default:
                return null;
            }
          },
        ),
      ),
    );
  }
}
