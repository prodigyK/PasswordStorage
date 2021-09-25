import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:password_storage_app/models/service.dart';
import 'package:password_storage_app/providers/mail_service_repository.dart';
import 'package:provider/provider.dart';

class MailServicesDetailScreen extends StatefulWidget {
  static const String routeName = '/mail-services-details';

  @override
  _MailServicesDetailScreen createState() => _MailServicesDetailScreen();
}

class _MailServicesDetailScreen extends State<MailServicesDetailScreen> {
  Service service;
  bool _firstInit = true;
  bool _isNew = true;
  bool _ssl = false;
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _deliveryAddressController = TextEditingController();
  final _deliveryPortController = TextEditingController();
  final _sendAddressController = TextEditingController();
  final _sendPortController = TextEditingController();

  static const double prefixWidth = 100.0;

  @override
  void didChangeDependencies() {
    if (_firstInit) {
      var ser = ModalRoute.of(context).settings.arguments as Map<String, Service>;
      service = ser != null ? ser['service'] : null;
      _isNew = service == null;
    }
    _firstInit = false;

    if (!_isNew) {
      _nameController.text = service.name;
      _deliveryAddressController.text = service.deliveryAddress;
      _deliveryPortController.text = service.deliveryPort;
      _sendAddressController.text = service.sendAddress;
      _sendPortController.text = service.sendPort;
      _ssl = service.ssl == null ? false : service.ssl;
    } else {
      service = Service(
        id: null,
        name: null,
        deliveryAddress: null,
        deliveryPort: null,
        sendAddress: null,
        sendPort: null,
        ssl: null,
        modifiedAt: DateTime.now(),
      );
    }

    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _deliveryAddressController.dispose();
    _deliveryPortController.dispose();
    _sendAddressController.dispose();
    _sendPortController.dispose();

    super.dispose();
  }

  void _saveForm() async {
    if (!_formKey.currentState.validate()) {
      return;
    }
    service = Service(
      id: service.id,
      name: _nameController.text,
      deliveryAddress: _deliveryAddressController.text,
      deliveryPort: _deliveryPortController.text,
      sendAddress: _sendAddressController.text,
      sendPort: _sendPortController.text,
      ssl: _ssl,
      modifiedAt: DateTime.now(),
    );

    if (!_isNew) {
      await _updateService();
    } else {
      await _addService();
    }

    Navigator.of(context).pop();
  }

  Future<void> _addService() async {
    final provider = Provider.of<MailServiceRepository>(context, listen: false);
    bool result = await provider.addService(service);
    result ? _showSnackbar('Mail Service is Added') : _showSnackbar('Failed to Add Service');
  }

  Future<void> _updateService() async {
    final provider = Provider.of<MailServiceRepository>(context, listen: false);
    bool result = await provider.updateService(service);
    result ? _showSnackbar('Mail Service is Updated') : _showSnackbar('Failed to Updated Service');
  }

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, textAlign: TextAlign.center),
        duration: Duration(seconds: 3),
      ),
    );
  }

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
      child: Scaffold(
        appBar: AppBar(
          title: Text('Add Mail Services'),
            backgroundColor: Colors.blue.shade200,
          actions: [
            TextButton(
              child: Text('Save', style: TextStyle(color: Colors.white, fontSize: 18)),
              onPressed: () {
                _saveForm();
              },
            )
          ],
        ),
        backgroundColor: Colors.white,
        body: Form(
            key: _formKey,
            child: Column(
              children: [
                CupertinoFormSection.insetGrouped(
                  header: Text('Domain Name'),
                  children: [
                    CupertinoTextFormFieldRow(
                      controller: _nameController,
                      prefix: Container(
                        width: prefixWidth,
                        child: Text('Domain'),
                      ),
                      placeholder: 'Domain Name',
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Enter Domain Name';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
                CupertinoFormSection.insetGrouped(
                  header: Text('POP/IMAP Server'),
                  children: [
                    CupertinoTextFormFieldRow(
                      controller: _deliveryAddressController,
                      prefix: Container(
                        width: prefixWidth,
                        child: Text('POP/IMAP'),
                      ),
                      placeholder: 'pop.' + '${service.name}',
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        return null;
                      },
                    ),
                    CupertinoTextFormFieldRow(
                      controller: _deliveryPortController,
                      prefix: Container(
                        width: prefixWidth,
                        child: Text('Port'),
                      ),
                      placeholder: '993',
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        return null;
                      },
                    ),
                  ],
                ),
                CupertinoFormSection.insetGrouped(
                  header: Text('SMTP Server'),
                  children: [
                    CupertinoTextFormFieldRow(
                      controller: _sendAddressController,
                      prefix: Container(
                        width: prefixWidth,
                        child: Text('SMTP'),
                      ),
                      placeholder: 'smtp.' + '${service.name}',
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        return null;
                      },
                    ),
                    CupertinoTextFormFieldRow(
                      controller: _sendPortController,
                      prefix: Container(
                        width: prefixWidth,
                        child: Text('Port'),
                      ),
                      placeholder: '465',
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        return null;
                      },
                    ),
                  ],
                ),
                CupertinoFormSection.insetGrouped(
                  header: Text('Security'),
                  children: [
                    CupertinoFormRow(
                      child: CupertinoSwitch(
                        value: _ssl,
                        onChanged: (value) {
                          setState(() {
                            _ssl = value;
                          });
                        },
                      ),
                      prefix: Text('SSL'),
                    ),
                  ],
                ),
              ],
            )),
      ),
    );
  }
}
