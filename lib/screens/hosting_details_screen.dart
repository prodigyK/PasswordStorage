import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:password_storage_app/models/hosting.dart';

class HostingDetailsScreen extends StatefulWidget {
  static const routeName = 'hosting-details-screen';

  @override
  _HostingDetailsScreenState createState() => _HostingDetailsScreenState();
}

class _HostingDetailsScreenState extends State<HostingDetailsScreen> {
  bool isNew = false;
  bool firstInit = true;
  Hosting hosting;
  String hostingId;

  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _urlController = TextEditingController();
  final _hostingLoginController = TextEditingController();
  final _hostingPassController = TextEditingController();
  final _rdpIpController = TextEditingController();
  final _rdpLoginController = TextEditingController();
  final _rdpPassController = TextEditingController();

  final _urlFocusNode = FocusNode();
  final _hostingLoginFocus = FocusNode();
  final _hostingPassFocus = FocusNode();
  final _rdpIpFocus = FocusNode();
  final _rdpLoginFocus = FocusNode();
  final _rdpPassFocus = FocusNode();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _urlController.dispose();
    _hostingLoginController.dispose();
    _hostingPassController.dispose();
    _rdpIpController.dispose();
    _rdpLoginController.dispose();
    _rdpPassController.dispose();

    _urlFocusNode.dispose();
    _hostingLoginFocus.dispose();
    _hostingPassFocus.dispose();
    _rdpIpFocus.dispose();
    _rdpLoginFocus.dispose();
    _rdpPassFocus.dispose();

    super.dispose();
  }

  @override
  void didChangeDependencies() {
    if (firstInit) {
      final settings = ModalRoute.of(context).settings.arguments as Map<String, Object>;
      hosting = settings != null ? settings['hosting'] as Hosting : null;
      hostingId = hosting != null && hosting.id != null ? hosting.id : '';
      isNew = hosting == null || hostingId.isEmpty;
    }
    firstInit = false;

    if (!isNew) {
      _nameController.text = hosting.name;
      _urlController.text = hosting.hostingName;
      _hostingLoginController.text = hosting.hostingLogin;
      _hostingPassController.text = hosting.hostingPass;
      _rdpIpController.text = hosting.rdpIp;
      _rdpLoginController.text = hosting.rdpLogin;
      _rdpPassController.text = hosting.rdpPass;
    }

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final prefixWidth = 80.0;

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text('Hosting Details'),
        trailing: GestureDetector(
          child: Text('Save'),
          onTap: (){},
        ),
      ),
      child: SingleChildScrollView(
        child: SafeArea(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                CupertinoFormSection.insetGrouped(
                  header: Text('Title'),
                  children: [
                    CupertinoTextFormFieldRow(
                      controller: _nameController,
                      prefix: Container(
                        width: prefixWidth,
                        child: Text('Name'),
                      ),
                      placeholder: 'Server\'s Name',
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_urlFocusNode);
                      },
                    ),
                  ],
                ),
                CupertinoFormSection.insetGrouped(
                  header: Text('Hosting Credentials'),
                  children: [
                    CupertinoTextFormFieldRow(
                      controller: _urlController,
                      focusNode: _urlFocusNode,
                      prefix: Container(
                        width: prefixWidth,
                        child: Text('Hosting'),
                      ),
                      placeholder: 'Hosting Url',
                      keyboardType: TextInputType.url,
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_hostingLoginFocus);
                      },
                    ),
                    CupertinoTextFormFieldRow(
                      controller: _hostingLoginController,
                      focusNode: _hostingLoginFocus,
                      prefix: Container(
                        width: prefixWidth,
                        child: Text('Login'),
                      ),
                      placeholder: 'Hosting Login',
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_hostingPassFocus);
                      },
                    ),
                    CupertinoTextFormFieldRow(
                      controller: _hostingPassController,
                      focusNode: _hostingPassFocus,
                      prefix: Container(
                        width: prefixWidth,
                        child: Text('Pass'),
                      ),
                      placeholder: 'Hosting Password',
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_rdpIpFocus);
                      },
                    ),
                  ],
                ),
                CupertinoFormSection.insetGrouped(
                  header: Text('RDP Credentials'),
                  children: [
                    CupertinoTextFormFieldRow(
                      controller: _rdpIpController,
                      focusNode: _rdpIpFocus,
                      prefix: Container(
                        width: prefixWidth,
                        child: Text('IP'),
                      ),
                      placeholder: 'Rdp Ip Address',
                      keyboardType: TextInputType.numberWithOptions(decimal: true),
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_rdpLoginFocus);
                      },
                    ),
                    CupertinoTextFormFieldRow(
                      controller: _rdpLoginController,
                      focusNode: _rdpLoginFocus,
                      prefix: Container(
                        width: prefixWidth,
                        child: Text('Login'),
                      ),
                      placeholder: 'RDP Login',
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_rdpPassFocus);
                      },
                    ),
                    CupertinoTextFormFieldRow(
                      controller: _rdpPassController,
                      focusNode: _rdpPassFocus,
                      prefix: Container(
                        width: prefixWidth,
                        child: Text('Pass'),
                      ),
                      placeholder: 'RDP Pass',
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.done,
                      onFieldSubmitted: (_) {
//                  FocusScope.of(context).requestFocus(_rdpPassFocus);
                      },
                    ),

                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
