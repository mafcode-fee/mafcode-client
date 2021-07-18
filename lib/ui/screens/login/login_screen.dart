import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mafcode/core/di/providers.dart';
import 'package:mafcode/ui/auto_router_config.gr.dart';
import 'package:mafcode/ui/shared/error_utils.dart';
import 'package:mafcode/ui/shared/logo_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends HookWidget {
  @override
  Widget build(BuildContext context) {
    useMemoized(() async {
      final sharedPref = await SharedPreferences.getInstance();
      if (sharedPref.containsKey("token")) {
        Navigator.of(context).pushReplacementNamed(Routes.mainScreen);
      }
    });
    final showSpinner = useState(false);
    final error = useState<String>();
    final emailController = useTextEditingController();
    final passwordController = useTextEditingController();
    final api = useProvider(apiProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text("Login"),
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
                    controller: emailController,
                    decoration: InputDecoration(labelText: "Email"),
                  ),
                  TextField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: InputDecoration(labelText: "Password"),
                  ),
                  SizedBox(height: 24),
                  if (error.value != null)
                    Text(
                      error.value,
                      style: TextStyle(color: Colors.red),
                    ),
                  Row(
                    children: [
                      TextButton(
                        child: Text("Register"),
                        onPressed: () async {
                          Navigator.of(context).pushNamed(Routes.registrationScreen);
                        },
                      ),
                      Spacer(),
                      if (showSpinner.value)
                        CircularProgressIndicator()
                      else
                        ElevatedButton(
                          child: Row(
                            children: [
                              Text("Login"),
                            ],
                          ),
                          onPressed: () async {
                            showSpinner.value = true;
                            error.value = null;
                            print('Posting data...');
                            try {
                              final loginResult = await api.login(
                                emailController.text,
                                passwordController.text,
                              );
                              final sharedPref = await SharedPreferences.getInstance();
                              sharedPref.setString('token', loginResult.accessToken);
                              Navigator.of(context).pushReplacementNamed(Routes.mainScreen);
                              showSpinner.value = false;
                            } on Exception catch (e) {
                              print(e);
                              error.value = ErrorUtils.getMessage(e);
                              showSpinner.value = false;
                            }
                            //                  await post().then((value){
                            //                    print(value);
                            //                  });
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
    );
  }
}
