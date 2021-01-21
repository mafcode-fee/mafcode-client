import 'package:auto_route/auto_route_annotations.dart';
import 'package:flutter/material.dart';
import 'package:mafcode/ui/auto_router_config.gr.dart';
import 'package:mafcode/ui/shared/logo_widget.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            LogoWidget(),
            SizedBox(height: 48),
            TextField(
              decoration: InputDecoration(labelText: "Username"),
            ),
            TextField(
              obscureText: true,
              decoration: InputDecoration(labelText: "Password"),
            ),
            SizedBox(height: 24),
            Align(
              alignment: Alignment.centerRight,
              child: RaisedButton(
                color: Theme.of(context).primaryColor,
                textColor: Colors.white,
                child: Text("Login"),
                onPressed: () {
                  Navigator.of(context).pushReplacementNamed(Routes.mainScreen);
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
