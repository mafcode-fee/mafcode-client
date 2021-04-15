import 'package:auto_route/auto_route_annotations.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
//import 'package:mafcode/ui/auto_router_config.gr.dart';
import 'package:mafcode/ui/shared/logo_widget.dart';
import 'package:http/http.dart' as http;

class LoginScreen extends StatefulWidget {

  const LoginScreen({Key key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String email;
  String password;

  Dio dio = new Dio();
  Future postData() async{
    final String url = 'http://13.92.138.210:4000/login';
    var response = await dio.post(url,data: {
      "email": email,
      "password":password
    });
    return response.data;
//  post() async{
//    final uri = 'http://13.92.138.210:4000/login';
//    var map = new Map<String, dynamic>();
//    map['username'] = email;
//    map['password'] = password;
//
//    http.Response response = await http.post(
//      uri,
//      body: map,
//    );
//  }





  }
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
                onPressed: () async{
                  print('Posting data...');
                  await postData().then((value) {
                    print(value);
                  });
//                  await post().then((value){
//                    print(value);
//                  });

                  //Navigator.of(context).pushReplacementNamed(Routes.mainScreen);
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
