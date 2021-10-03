import 'package:diary/screen/home.dart';
import 'package:diary/login/signup.dart';
import 'package:diary/screen/home2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

class Emaillogin extends StatefulWidget {
  const Emaillogin({Key? key}) : super(key: key);

  @override
  _EmailloginState createState() => _EmailloginState();
}

class _EmailloginState extends State<Emaillogin> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _islogin = false;

  _login() async {
    setState(() {
      _islogin = true;
    });

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailController.text, password: _passwordController.text);
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => Homepage1()));
    } on FirebaseAuthException catch (e) {
      var message = '';
      switch (e.code) {
        case 'wrong-password':
          message = "incorrect password";
          break;
        case 'user-not-found':
          message = "user not found";
          break;
        case 'user-disabled':
          message = "user you tried to login is disabled";
          break;
        case 'invalid-email':
          message = "you enterd an invalid email";
          break;
      }
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("login failed"),
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
    } finally {
      setState(() {
        _islogin = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text("login here",
              style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontSize: 25,
                  fontWeight: FontWeight.w600)),
          SizedBox(
            height: 20,
          ),
          SizedBox(
            height: 5,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 16),
            child: TextField(
              controller: _emailController,
              decoration: InputDecoration(
                  labelText: "Email",
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Theme.of(context).primaryColor,
                    ),
                  )),
              keyboardType: TextInputType.emailAddress,
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 16),
            child: TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                  labelText: "Password",
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Theme.of(context).primaryColor,
                    ),
                  )),
              obscureText: true,
            ),
          ),
          if (!_islogin)
            Padding(
              padding: const EdgeInsets.only(left: 50, right: 50),
              child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                      onPressed: () {
                        _login();
                      },
                      child: Text("login"))),
            ),
          if (_islogin) ...[
            SizedBox(
              height: 10,
            ),
            Center(
              child: CircularProgressIndicator(),
            ),
          ],
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 30,
              ),
              Text("you don't have an account?"),
              new GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => Signuppage()));
                },
                child: Text(" Signup",
                    style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: 15,
                        fontWeight: FontWeight.w600)),
              )
            ],
          ),
        ]),
      ),
    );
  }
}
