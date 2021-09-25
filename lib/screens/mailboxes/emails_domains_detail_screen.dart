import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:password_storage_app/models/domain.dart';
import 'package:password_storage_app/models/service.dart';
import 'package:password_storage_app/providers/mail_domain_repository.dart';
import 'package:password_storage_app/providers/mail_service_repository.dart';
import 'package:provider/provider.dart';

class MailboxDomainDetailScreen extends StatefulWidget {
  static const String routeName = '/mail-domains-details';

  @override
  _MailboxDomainDetailScreenState createState() => _MailboxDomainDetailScreenState();
}

class _MailboxDomainDetailScreenState extends State<MailboxDomainDetailScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final double prefixWidth = 80;
  bool _firstInit = true;
  Domain domain;
  bool _isNew;
  Service selectedService = null;
  List<Service> services = [];

  @override
  void didChangeDependencies() async {
    if (_firstInit) {
      final ref = ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
      _isNew = ref['isNew'];
      if (!_isNew) {
        final ref = ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
        domain = ref['domain'];
      } else {
        domain = Domain(
          id: '',
          name: '',
          serviceId: '',
          modifiedAt: DateTime.now(),
        );
      }
      services = await Provider.of<MailServiceRepository>(context, listen: false).getAllDocuments();
      selectedService = _isNew ? services.first : services.firstWhere((service) => service.id == domain.serviceId);
      setState(() {
        _nameController.text = domain.name;
      });
    }
    _firstInit = false;

    super.didChangeDependencies();
  }

  void _saveForm() async {
    if (!_formKey.currentState.validate()) {
      return;
    }

    domain = Domain(
      id: _isNew ? null : domain.id,
      name: _nameController.text,
      modifiedAt: DateTime.now(),
      serviceId: selectedService.id,
    );

    if (_isNew) {
      await _addDomain();
    } else {
      await _updateDomain();
    }

    Navigator.of(context).pop();
  }

  Future<void> _addDomain() async {
    final provider = Provider.of<MailDomainRepository>(context, listen: false);
    bool result = await provider.addDomain(domain);
    result ? _showSnackbar('Domain is Added') : _showSnackbar('Failed to Add Domain');
  }

  Future<void> _updateDomain() async {
    final provider = Provider.of<MailDomainRepository>(context, listen: false);
    bool result = await provider.updateDomain(domain);
    result ? _showSnackbar('Domain is Updated') : _showSnackbar('Failed to Updated Domain');
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
  void dispose() {
    _nameController.dispose();
    super.dispose();
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
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text('Details'),
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
        body: Container(
          padding: EdgeInsets.symmetric(horizontal: 8.0),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 5),
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: 'Domain Name',
                      prefixIcon: GestureDetector(
                        child: Icon(Icons.domain),
                        onTap: () {
                          Clipboard.setData(ClipboardData(text: "${domain.name}"));
                          _showSnackbar('Copied to Clipboard');
                        },
                      ),
                      suffixIcon: GestureDetector(
                        child: Icon(Icons.remove_circle_outline),
                        onTap: () {
                          _nameController.clear();
                        },
                      ),
                    ),
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (_) {
                      // FocusScope.of(context).requestFocus(_urlFocusNode);
                    },
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Enter Domain Name';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 5),
                  Container(
                    // width: double.infinity,
                    // height: 60,
                    // color: Colors.blue.shade200,
                    alignment: Alignment.centerLeft,
                    margin: EdgeInsets.symmetric(horizontal: 8.0),
                    padding: EdgeInsets.symmetric(horizontal: 24.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16.0),
                      color: Colors.grey.shade200,
                    ),
                    child: DropdownButton<Service>(
                      value: selectedService,
                      icon: const Icon(Icons.keyboard_arrow_down),
                      iconSize: 24,
                      elevation: 16,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.normal,
                      ),
                      borderRadius: BorderRadius.circular(16.0),
                      dropdownColor: Colors.blue.shade50,
                      isExpanded: true,
                      underline: Container(
                        height: 2,
                        color: Colors.transparent,
                      ),
                      onChanged: (Service newValue) {
                        setState(() {
                          selectedService = newValue;
                        });
                      },
                      items: services.map<DropdownMenuItem<Service>>((service) {
                        // print('DropdownMenuItem $domain');
                        return DropdownMenuItem<Service>(
                          value: service,
                          child: Text(service.name),
                        );
                      }).toList(),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
