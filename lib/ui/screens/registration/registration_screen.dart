import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mafcode/core/di/providers.dart';
import 'package:mafcode/ui/auto_router_config.gr.dart';
import 'package:mafcode/ui/shared/error_utils.dart';
import 'package:mafcode/ui/shared/logo_widget.dart';
import 'package:validators/validators.dart';

class RegistrationScreen extends StatefulHookWidget {
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  int statusCode;
  final passwordRegex = RegExp("^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)");
  // email,first_name,last_name,password
  final firstNameTextController = TextEditingController();
  final lastNameTextController = TextEditingController();
  final emailTextController = TextEditingController();
  final passwordTextController = TextEditingController();
  final confirmedPasswordTextController = TextEditingController();
  final contactTextController = TextEditingController();

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

  bool checkRegistrationInput() {
    if (!isEmail(emailTextController.text)) {
      showMafcodeDialog(message: "Please enter a valid email", title: "Error");
      return false;
    }
    if (!equals(passwordTextController.text, confirmedPasswordTextController.text)) {
      showMafcodeDialog(message: "The two passwords don't match", title: "Error!");
      return false;
    }
    if (!isLength(passwordTextController.text, 8, 20)) {
      showMafcodeDialog(message: "Please enter a password that is between 5 and 30 characters long", title: "Error");
      return false;
    }
    if (!passwordRegex.hasMatch(passwordTextController.text)) {
      showMafcodeDialog(
          message: "Please enter a password that contains at least 1 number and 1 lowercase and 1 uppercase letters",
          title: "Error");
      return false;
    }
    return true;
  }

  Future<void> showMafcodeDialog({String message, String title}) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
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
    final api = useProvider(apiProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text('Registration'),
      ),
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
                    decoration: InputDecoration(
                      labelText: "First Name",
                    ),
                    controller: firstNameTextController,
                    textInputAction: TextInputAction.next,
                  ),
                  TextField(
                    decoration: InputDecoration(labelText: "Last Name"),
                    controller: lastNameTextController,
                    textInputAction: TextInputAction.next,
                  ),
                  TextField(
                    decoration: InputDecoration(labelText: "Email"),
                    controller: emailTextController,
                    textInputAction: TextInputAction.next,
                  ),
                  TextField(
                    decoration: InputDecoration(labelText: "Contact Information"),
                    controller: contactTextController,
                    textInputAction: TextInputAction.next,
                  ),
                  TextField(
                    obscureText: true,
                    decoration: InputDecoration(labelText: "Password"),
                    controller: passwordTextController,
                    textInputAction: TextInputAction.next,
                  ),
                  TextField(
                    obscureText: true,
                    decoration: InputDecoration(labelText: "Confirm Password"),
                    controller: confirmedPasswordTextController,
                    textInputAction: TextInputAction.done,
                  ),
                  SizedBox(height: 24),
                  Align(
                    alignment: Alignment.center,
                    child: ElevatedButton(
                      child: Text(
                        "Register",
                      ),
                      onPressed: () async {
                        if (!checkRegistrationInput()) return;
                        try {
                          await api.register(
                              email: emailTextController.text,
                              password: passwordTextController.text,
                              firstName: firstNameTextController.text,
                              lastName: lastNameTextController.text,
                              contact: contactTextController.text);

                          showMafcodeDialog(
                              message: "Registeration Done Successfully, Please login with your information",
                              title: "Success!");

                          Future.delayed(Duration(milliseconds: 2000), () {
                            Navigator.of(context).pushNamedAndRemoveUntil(Routes.loginScreen, (_) => false);
                          });
                        } catch (e, stackTracke) {
                          debugPrintStack(label: e.toString(), stackTrace: stackTracke);
                          final errMessage = ErrorUtils.getMessage(e);
                          showMafcodeDialog(message: errMessage, title: "Error!");
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
