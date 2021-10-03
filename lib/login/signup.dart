import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diary/screen/home.dart';
import 'package:diary/screen/home2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Signuppage extends StatefulWidget {
  const Signuppage({Key? key}) : super(key: key);

  @override
  _SignuppageState createState() => _SignuppageState();
}

class _SignuppageState extends State<Signuppage> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmpasswordController = TextEditingController();

  var loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      // title: Text("Signup"),
      //),
      body: Container(
        child: Form(
            key: _formKey,
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Text("Create account",
                  style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize: 25,
                      fontWeight: FontWeight.w600)),
              SizedBox(height: 20),
              Fieldcontroller(
                label: 'Name',
                controller: _nameController,
                keyboardType: TextInputType.name,
                validator: _requiredvalidator,
              ),
              SizedBox(height: 10),
              Fieldcontroller(
                label: 'Email',
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                validator: _requiredvalidator,
              ),
              SizedBox(height: 10),
              Fieldcontroller(
                label: 'password',
                controller: _passwordController,
                keyboardType: TextInputType.name,
                validator: _requiredvalidator,
                password: true,
              ),
              SizedBox(height: 10),
              Fieldcontroller(
                label: 'Confirm password',
                controller: _confirmpasswordController,
                keyboardType: TextInputType.name,
                validator: __confirmpasswordedvalidator,
                password: false,
              ),
              SizedBox(height: 5),
              if (!loading) ...[
                Padding(
                  padding: const EdgeInsets.only(left: 50, right: 50),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState != null &&
                            _formKey.currentState!.validate()) ;
                        _signup();
                      },
                      child: Text("signup"),
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text("back"),
                ),
              ],
              if (loading) ...[
                SizedBox(
                  height: 10,
                ),
                Center(
                  child: CircularProgressIndicator(),
                ),
              ],
            ])),
      ),
    );
  }

  String? _requiredvalidator(String? text) {
    if (text == null || text.trim().isEmpty) {
      return 'this field required';
    }
    return null;
  }

  String? __confirmpasswordedvalidator(String? confirmpassword) {
    if (confirmpassword == null || confirmpassword.trim().isEmpty) {
      return 'this field required';
    }
    if (_passwordController.text != confirmpassword) {
      return "password don't match";
    }
    return null;
  }

  Future _signup() async {
    setState(() {
      loading = true;
    });
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text, password: _passwordController.text);

      await FirebaseFirestore.instance.collection('users').add({
        'name': _nameController.text,
        'email': _emailController.text,
        'password': _passwordController.text
      });
      print("creatwd......");
      await showDialog(
        context: context,
        builder: (context) => AlertDialog(
            title: Text("Sign up succeed"),
            content:
                Text("Your account has been created,please login to continue"),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => Homepage1()));
                    setState(() {
                      loading = false;
                    });
                  },
                  child: Text("ok")),
            ]),
      );
      Navigator.of(context).pop();
    } on FirebaseAuthException catch (e) {
      _handlesignuperror(e);
    } finally {
      setState(() {
        loading = false;
      });
    }
  }

  void _handlesignuperror(FirebaseAuthException e) {
    String message;
    switch (e.code) {
      case 'email-already-in-use':
        message = "this email id already in use";
        break;
      case 'invalid-email':
        message = "Invalid email id";
        break;
      case 'operation-not-allowed':
        message = "this operation is not allowed";
        break;
      case 'weak-password':
        message = "your pasword isvery weak";
        break;
      default:
        message = "An unknown error occured";
        break;
    }
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("signup failed"),
            content: Text(message),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("ok"),
              ),
            ],
          );
        });
  }
}

class Fieldcontroller extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final bool password;
  final TextInputType keyboardType;
  final FormFieldValidator<String> validator;

  const Fieldcontroller({
    Key? key,
    required this.controller,
    required this.label,
    required this.validator,
    required this.keyboardType,
    this.password = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, right: 16),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
            labelText: label,
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Theme.of(context).primaryColor,
              ),
            )),
        keyboardType: keyboardType,
        obscureText: password,
        validator: validator,
      ),
    );
  }
}
