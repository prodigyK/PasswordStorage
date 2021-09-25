import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:password_storage_app/models/domain.dart';
import 'package:password_storage_app/models/mailbox.dart';
import 'package:password_storage_app/providers/mail_domain_repository.dart';
import 'package:password_storage_app/providers/mailbox_repository.dart';
import 'package:password_storage_app/providers/encryption.dart';
import 'package:provider/provider.dart';

class MailboxDetailScreen extends StatefulWidget {
  static const String routeName = '/mailbox-detail';

  @override
  _MailboxDetailScreenState createState() => _MailboxDetailScreenState();
}

class _MailboxDetailScreenState extends State<MailboxDetailScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _passwordController = TextEditingController();
  Domain selectedDomain;
  bool firstInit = true;
  List<Domain> domains = [];
  String fullEmail = '';
  bool enabledSaveButton = false;
  Mailbox mailbox;
  bool isNew = true;

  @override
  void dispose() {
    _nameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() async {
    if (firstInit) {
      final ref = ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
      isNew = ref['isNew'];
      if (isNew) {
        mailbox = Mailbox(
          id: '',
          name: '',
          password: '',
          modifiedAt: DateTime.now(),
          domainId: '',
        );
      } else {
        mailbox = ref['mailbox'];
        enabledSaveButton = true;
      }
      _nameController.text = isNew ? '' : mailbox.name.split('@')[0];
      _passwordController.text =
          isNew ? '' : Provider.of<Encryption>(context, listen: false).decrypt(encoded: mailbox.password);

      domains = await Provider.of<MailDomainRepository>(context, listen: false).getAllDocuments();
      setState(() {
        selectedDomain = isNew ? domains.first : domains.firstWhere((domain) => domain.id == mailbox.domainId);
        fullEmail = isNew ? '@${selectedDomain.name}' : mailbox.name;
      });
    }
    firstInit = false;

    super.didChangeDependencies();
  }

  void _showSnackbar(String message, {bool error = false}) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, textAlign: TextAlign.center),
        duration: Duration(seconds: 5),
        backgroundColor: error ? Colors.red : Colors.black,
      ),
    );
  }

  void _saveForm() async {
    if (!_formKey.currentState.validate()) {
      return;
    }

    mailbox = Mailbox(
      id: isNew ? '' : mailbox.id,
      name: fullEmail,
      password: Provider.of<Encryption>(context, listen: false).encrypt(text: _passwordController.text),
      domainId: selectedDomain.id,
      modifiedAt: DateTime.now(),
    );

    if (isNew) {
      bool isExist = await Provider.of<MailboxRepository>(context, listen: false).contains(mailbox.name);
      if (isExist) {
        _showSnackbar('Mailbox already exists', error: true);
        return;
      }
      await _addMailbox();
    } else {
      bool isExist =
          await Provider.of<MailboxRepository>(context, listen: false).contains(mailbox.name, docID: mailbox.id);
      if (!isExist) {
        _showSnackbar('Cannot change existing mailbox', error: true);
        return;
      }
      await _updateMailbox();
    }

    Navigator.of(context).pop();
  }

  Future<void> _addMailbox() async {
    final provider = Provider.of<MailboxRepository>(context, listen: false);
    bool result = await provider.addMailbox(mailbox).then((value) => true).catchError((error) => false);
    result ? _showSnackbar('Mailbox is Added') : _showSnackbar('Failed to Add Mailbox', error: true);
  }

  Future<void> _updateMailbox() async {
    final provider = Provider.of<MailboxRepository>(context, listen: false);
    bool result = await provider.updateMailbox(mailbox).then((value) => true).catchError((error) => false);
    result ? _showSnackbar('Mailbox is Updated') : _showSnackbar('Failed to Update Mailbox', error: true);
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
          title: isNew ? Text('Add Mailbox') : Text('Modify Mailbox'),
          backgroundColor: Colors.blue.shade200,
        ),
        backgroundColor: Colors.white,
        body: Container(
          margin: EdgeInsets.symmetric(horizontal: 16.0),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20),
                  Text('Select Domain:', textAlign: TextAlign.left),
                  SizedBox(height: 10),
                  Container(
                    alignment: Alignment.centerLeft,
                    margin: EdgeInsets.symmetric(horizontal: 0.0),
                    padding: EdgeInsets.symmetric(horizontal: 24.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      color: Colors.grey.shade200,
                    ),
                    child: DropdownButton<Domain>(
                      value: selectedDomain,
                      icon: const Icon(Icons.keyboard_arrow_down),
                      iconSize: 24,
                      elevation: 8,
                      style: const TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
                      borderRadius: BorderRadius.circular(8.0),
                      dropdownColor: Colors.blue.shade50,
                      isExpanded: true,
                      underline: Container(
                        height: 2,
                        color: Colors.transparent,
                      ),
                      onChanged: isNew
                          ? (Domain newValue) {
                              setState(() {
                                selectedDomain = newValue;
                                fullEmail = _nameController.text + '@' + selectedDomain.name;
                              });
                            }
                          : null,
                      items: domains.map<DropdownMenuItem<Domain>>((domain) {
                        return DropdownMenuItem<Domain>(
                          value: domain,
                          child: Text(domain.name),
                        );
                      }).toList(),
                    ),
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      // labelText: 'Email Address',
                      prefixIcon: GestureDetector(
                        child: Icon(Icons.email),
                        onTap: () {
                          Clipboard.setData(ClipboardData(text: fullEmail));
                          _showSnackbar('Copied to Clipboard');
                        },
                      ),
                      suffixIcon: GestureDetector(
                        child: Icon(Icons.remove_circle_outline),
                        onTap: () {
                          _nameController.clear();
                          setState(() {
                            enabledSaveButton = false;
                          });
                        },
                      ),
                    ),
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    maxLength: 30,
                    maxLines: 1,
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Enter Mailbox Name';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      enabledSaveButton = value.isNotEmpty;
                      setState(() {
                        fullEmail = value + '@' + selectedDomain.name;
                      });
                    },
                  ),
                  // SizedBox(height: 5),
                  TextFormField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      // labelText: 'Email Address',
                      prefixIcon: GestureDetector(
                        child: Icon(Icons.security),
                        onTap: () {
                          Clipboard.setData(ClipboardData(text: "${_passwordController.text}"));
                          _showSnackbar('Copied to Clipboard');
                        },
                      ),
                      suffixIcon: GestureDetector(
                        child: Icon(Icons.remove_circle_outline),
                        onTap: () {
                          _passwordController.clear();
                        },
                      ),
                    ),
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    maxLength: 30,
                    maxLines: 1,
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Enter Password';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  Container(
                    width: double.infinity,
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      color: Colors.blue.shade100,
                    ),
                    child: Center(
                      child: Text(
                        fullEmail,
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  SizedBox(height: 30),
                  Container(
                    width: double.infinity,
                    child: CupertinoButton(
                      child: Text('Save Mailbox'),
                      color: Colors.blue,
                      disabledColor: Colors.blue.shade50,
                      onPressed: enabledSaveButton
                          ? () {
                              _saveForm();
                            }
                          : null,
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
