import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:password_storage_app/models/hosting.dart';
import 'package:password_storage_app/providers/hosting_repository.dart';
import 'package:provider/provider.dart';

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
  bool isSaving = false;

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
      hosting = settings != null ? settings['hosting'] as Hosting : Hosting();
      hostingId = hosting.id != null ? hosting.id : null;
      isNew = hosting.id == null;
      firstInit = false;
    }

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

  void _saveForm() async {
    if (!_formKey.currentState.validate()) {
      return;
    }
    _formKey.currentState.save();

    hosting.id = isNew ? null : hostingId;
    hosting.name = _nameController.text;
    hosting.hostingName = _urlController.text;
    hosting.hostingLogin = _hostingLoginController.text;
    hosting.hostingPass = _hostingPassController.text;
    hosting.rdpIp = _rdpIpController.text;
    hosting.rdpLogin = _rdpLoginController.text;
    hosting.rdpPass = _rdpPassController.text;

    if (isNew) {
      await Provider.of<HostingRepository>(context, listen: false).addHosting(hosting);
    } else {
      await Provider.of<HostingRepository>(context, listen: false).updateHosting(hosting);
    }
    Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    final prefixWidth = 80.0;

    return Center(
      child: LayoutBuilder(builder: (context, constraints) {
        if (constraints.maxWidth > 600) {
          return _buildScaffold(prefixWidth, context, width: 600);
        } else {
          return _buildScaffold(prefixWidth, context, width: double.infinity);
        }
      }),
    );
  }

  Widget _buildScaffold(double prefixWidth, BuildContext context, {double width}) {
    return Container(
      width: width,
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: width),
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: Text('Hosting Details'),
            backgroundColor: Colors.orange.shade200,
            actions: [
              TextButton(
                child: Text('Save', style: TextStyle(color: Colors.white, fontSize: 18)),
                onPressed: _saveForm,
              ),
            ],
          ),
          body: isSaving
              ? Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
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
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Enter correct name';
                                  }
                                  return null;
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
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Enter a hosting';
                                  }
                                  return null;
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
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Enter a login';
                                  }
                                  return null;
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
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Enter a password';
                                  }
                                  return null;
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
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Enter Ip address';
                                  }
                                  return null;
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
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Enter rdp login';
                                  }
                                  return null;
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
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Enter rdp password';
                                  }
                                  return null;
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}
