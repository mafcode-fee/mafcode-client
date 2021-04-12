import 'package:flutter/material.dart';
import 'package:mafcode/ui/shared/logo_widget.dart';
import 'package:validators/validators.dart';
import 'package:dio/dio.dart';
import 'package:mafcode/ui/auto_router_config.gr.dart';

class RegistrationScreen extends StatefulWidget {
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  int statusCode;
  // email,first_name,last_name,password
  final firstNameTextController = TextEditingController();
  final lastNameTextController = TextEditingController();
  final emailTextController = TextEditingController();
  final passwordTextController = TextEditingController();
  final confirmedPasswordTextController = TextEditingController();

  String firstName;
  String lastName;
  String email;
  String password;
  String confirmedPassword;

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the
    // widget tree.
    firstNameTextController.dispose();
    lastNameTextController.dispose();
    emailTextController.dispose();
    passwordTextController.dispose();
    confirmedPasswordTextController.dispose();
    super.dispose();
  }

  checkRegistrationInput(String firstName, String lastName, String email,
      String password, String confirmedPassword) {
    bool correctEmail = isEmail(email);
    bool correctPassword = equals(password, confirmedPassword);
    bool passwordLength = isLength(
      password,
      5,
      30,
    );
    if (!correctEmail)
      return 104;
    else if (!correctPassword)
      return 204;
    else if (!passwordLength)
      return 205;
    else
      return 000;
  }

  Future registerUser(
      String firstName, String lastName, String email, String password) async {
    var options = BaseOptions(
      baseUrl: 'http://13.92.138.210:4000',
    );
    var dio = Dio(options);
    var map = new Map<String, dynamic>();
    map['email'] = email;
    map['first_name'] = firstName;
    map['last_name'] = lastName;
    map['password'] = password;
    try {
      var formData = new FormData.fromMap(map);
      var response = await dio.post('/register', data: formData);
      return response.data;
    } catch (e) {
      print(e);
    }
  }

  Future<void> _showMyDialog(String message, {bool success = false}) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(!success ? 'Error!' : "Success!"),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(message),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Dismess'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(new FocusNode());
          },
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  LogoWidget(),
                  SizedBox(height: 48),
                  TextField(
                    decoration: InputDecoration(labelText: "First Name"),
                    controller: firstNameTextController,
                  ),
                  TextField(
                    decoration: InputDecoration(labelText: "Last Name"),
                    controller: lastNameTextController,
                  ),
                  TextField(
                    decoration: InputDecoration(labelText: "Email"),
                    controller: emailTextController,
                  ),
                  TextField(
                    obscureText: true,
                    decoration: InputDecoration(labelText: "Password"),
                    controller: passwordTextController,
                  ),
                  TextField(
                    obscureText: true,
                    decoration: InputDecoration(labelText: "Confirm Password"),
                    controller: confirmedPasswordTextController,
                  ),
                  SizedBox(height: 24),
                  Align(
                    alignment: Alignment.center,
                    child: RaisedButton(
                      color: Theme.of(context).primaryColor,
                      textColor: Colors.white,
                      child: Text(
                        "Register",
                        style: TextStyle(fontSize: 20),
                      ),
                      onPressed: () async {
                        statusCode = checkRegistrationInput(
                            firstNameTextController.text,
                            lastNameTextController.text,
                            emailTextController.text,
                            passwordTextController.text,
                            confirmedPasswordTextController.text);
                        switch (statusCode) {
                          case 104:
                            _showMyDialog("Please enter a valid email");
                            break;
                          case 204:
                            _showMyDialog("The two passwords don't match");
                            break;
                          case 205:
                            _showMyDialog(
                                "Please enter a password that is between 5 and 30 characters long");
                            break;
                          case 000:
                            firstName = firstNameTextController.text;
                            lastName = lastNameTextController.text;
                            email = emailTextController.text;
                            password = passwordTextController.text;
                            Map response = await registerUser(
                                firstName, lastName, email, password);
                            if (response["message"] == "User Already Exist")
                              _showMyDialog(
                                  "This email already exists, please enter a different email");
                            else if (response["message"] ==
                                "User added sucessfully") {
                              _showMyDialog(
                                  "Registeration Done Successfully, Please login with your information",
                                  success: true);
                              Future.delayed(Duration(milliseconds: 3000), () {
                                Navigator.of(context)
                                    .pushReplacementNamed(Routes.loginScreen);
                              });
                            }
                            break;
                          default:
                        }
                      },
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
