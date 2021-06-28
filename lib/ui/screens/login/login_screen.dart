import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
//import 'package:mafcode/ui/auto_router_config.gr.dart';
import 'package:mafcode/ui/shared/logo_widget.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../../auto_router_config.gr.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool showSpinner = false;

  String error;

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  Dio dio = new Dio();

  @override
  void initState() {
    dio.interceptors.add(PrettyDioLogger());
    super.initState();
  }

  Future postData() async {
    final String url = 'http://13.92.138.210:4000/login';
    final map = {
      "email": emailController.text,
      "password": passwordController.text,
    };
    var response = await dio.post(url, data: FormData.fromMap(map));
    return response.data;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login"),
      ),
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
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
              if (error != null)
                Text(
                  error,
                  style: TextStyle(color: Colors.red),
                ),
              Row(
                children: [
                  TextButton(
                    child: Text("Register"),
                    onPressed: () async {
                      Navigator.of(context)
                          .pushNamed(Routes.registrationScreen);
                    },
                  ),
                  Spacer(),
                  ElevatedButton(
                    child: Text("Login"),
                    onPressed: () async {
                      setState(() {
                        showSpinner = true;
                        error = null;
                      });
                      print('Posting data...');
                      try {
                        final logUser = await postData();
                        if (logUser != null) {
                          Navigator.of(context)
                              .pushReplacementNamed(Routes.mainScreen);
                        }
                        setState(() {
                          showSpinner = false;
                        });
                      } on Exception catch (e) {
                        print(e);
                        setState(() {
                          error = e.toString();
                        });
                      }
//                  await post().then((value){
//                    print(value);
//                  });
                    },
                  ),
                ],
              ),
              TextButton(
                child: Text("Skip"),
                onPressed: () async {
                  Navigator.of(context).pushReplacementNamed(Routes.mainScreen);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
