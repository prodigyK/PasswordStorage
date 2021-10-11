import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AuthForm extends StatefulWidget {
  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _loginController = TextEditingController();
  final _passController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _passwordFocus = FocusNode();

  void _submitForm() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    try {
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _loginController.text,
        password: _passController.text,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        _showSnackbar('User not found: ${e.message}', error: true);
      } else if (e.code == 'wrong-password') {
        _showSnackbar('Wrong password provided: ${e.message}', error: true);
      } else {
        _showSnackbar(e.message ?? 'unknown error', error: true);
      }
    }
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

  @override
  void dispose() {
    _loginController.dispose();
    _passController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 350,
        padding: EdgeInsets.all(24.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          // border: Border.all(color: Colors.grey),
          color: Colors.white,
        ),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _loginController,
                  decoration: InputDecoration(
                    // prefixIcon: Icon(Icons.mail),
                    labelText: 'Email',
                  ),
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(_passwordFocus);
                  },
                  validator: (value) {
                    final val = value ?? '';
                    if (val.isEmpty) {
                      return 'Email cannot be empty.';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _passController,
                  focusNode: _passwordFocus,
                  decoration: InputDecoration(
                    // prefixIcon: Icon(Icons.security),
                    labelText: 'Password',
                  ),
                  keyboardType: TextInputType.text,
                  obscureText: true,
                  textInputAction: TextInputAction.done,
                  onFieldSubmitted: (_) {
                    _submitForm();
                  },
                  validator: (value) {
                    final val = value ?? '';
                    if (val.isEmpty) {
                      return 'Password cannot be empty.';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 50),
                Row(
                  children: [
                    Expanded(
                      child: CupertinoButton(
                        color: Colors.blue.shade300,
                        child: Text('Sign In'),
                        onPressed: _submitForm,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
