import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:password_storage_app/providers/encryption.dart';
import 'package:password_storage_app/providers/hosting_firestore_repository.dart';
import 'package:password_storage_app/screens/hostings/hosting_detail_screen.dart';
import 'package:provider/provider.dart';

class HostingScreen extends StatefulWidget {
  static const routeName = '/hosting-screen';

  @override
  _HostingScreenState createState() => _HostingScreenState();
}

class _HostingScreenState extends State<HostingScreen> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: LayoutBuilder(builder: (context, constraints) {
        if (constraints.maxWidth > 600) {
          return _buildScaffold(context, width: 600);
        } else {
          return _buildScaffold(context, width: double.infinity);
        }
      }),
    );
  }

  Widget _buildScaffold(BuildContext context, {double width}) {
    return Container(
      width: width,
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: width),
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: Text('Hostings'),
            backgroundColor: Colors.orange.shade200,
            actions: [
              IconButton(
                icon: Icon(Icons.add),
                onPressed: () {
                  Navigator.of(context).pushNamed(HostingDetailsScreen.routeName).then((value) async {
                    setState(() {});
                  });
                },
              ),
            ],
          ),
          body: RefreshIndicator(
            onRefresh: () {
              return Provider.of<HostingFirestoreRepository>(context, listen: false).getAllDocuments();
            },
            child: FutureBuilder(
                future: Provider.of<HostingFirestoreRepository>(context, listen: false).getAllDocuments(),
                builder: (ctx, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  var hostings = snapshot.data;
                  return Container(
                    margin: EdgeInsets.only(top: 10.0),
                    child: ListView.builder(
                      itemCount: hostings.length,
                      itemBuilder: (ctx, i) => Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                          child: Card(
                            elevation: 5,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                            ),
                            child: Container(
                              width: double.infinity,
                              height: 250,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade200,
                                border: Border.all(color: Colors.grey, width: 0.5),
                                borderRadius: BorderRadius.all(Radius.circular(10)),
                                boxShadow: [
                                  BoxShadow(
                                    blurRadius: 8,
                                    offset: Offset(0, 2),
                                    color: Colors.black26,
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    height: 45,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).primaryColor,
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(10),
                                        topRight: Radius.circular(10),
                                      ),
                                      gradient: LinearGradient(
                                        colors: [
                                          Colors.orange.withOpacity(0.9),
                                          Colors.orange.withOpacity(0.5),
                                        ],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ),
                                    ),
                                    padding: EdgeInsets.only(left: 20, right: 10),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          hostings[i].name,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 24,
                                            fontFamily: 'RobotoCondensed',
                                            color: Colors.white,
                                          ),
                                          textAlign: TextAlign.start,
                                        ),
                                        IconButton(
                                          icon: Icon(Icons.edit),
                                          color: Colors.white,
                                          onPressed: () {
                                            Navigator.of(context).pushNamed(
                                              HostingDetailsScreen.routeName,
                                              arguments: {'hosting': hostings[i]},
                                            ).then((value) {
                                              setState(() {});
                                            });
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 7),
                                  CartItem(text: hostings[i].hostingName, icon: Icons.http),
                                  CartItem(text: hostings[i].hostingLogin, icon: Icons.account_circle),
                                  CartItem(
                                    text: Provider.of<Encryption>(context, listen: false)
                                        .decrypt(encoded: hostings[i].hostingPass),
                                    icon: Icons.security,
                                  ),
                                  Divider(),
                                  CartItem(text: hostings[i].rdpIp, icon: Icons.place),
                                  CartItem(text: hostings[i].rdpLogin, icon: Icons.login),
                                  CartItem(
                                    text: Provider.of<Encryption>(context, listen: false)
                                        .decrypt(encoded: hostings[i].rdpPass),
                                    icon: Icons.security,
                                  ),
                                ],
                              ),
                            ),
                          )),
                    ),
                  );
                }),
          ),
        ),
      ),
    );
  }
}

class CartItem extends StatelessWidget {
  const CartItem({
    Key key,
    @required this.text,
    @required this.icon,
  }) : super(key: key);

  final String text;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 3),
      child: Row(
        children: [
          GestureDetector(
            child: Icon(
              icon,
              size: 22,
              color: Colors.blueGrey,
            ),
            onTap: () => _copyText(context, text),
          ),
          SizedBox(width: 13),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 18,
                fontFamily: 'Lato',
                fontWeight: FontWeight.bold,
              ),
              softWrap: true,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  void _copyText(BuildContext context, String text) {
    Clipboard.setData(ClipboardData(text: text));
    _showSnackbar(context, 'Copied to Clipboard');
  }

  void _showSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, textAlign: TextAlign.center),
        duration: Duration(seconds: 2),
      ),
    );
  }
}
