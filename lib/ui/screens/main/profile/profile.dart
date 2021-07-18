import 'package:flutter/material.dart';
import 'package:mafcode/ui/screens/main/profile/editProfile.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  bool showPassword = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(left: 16, right: 16),
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: ListView(children: [
            IconButton(
              icon: Container(
                padding: EdgeInsets.only(left: 10, top: 10, right: 10),
                alignment: Alignment.topRight,
                child: Icon(
                  Icons.settings,
                  color: Colors.black,
                  size: 40.0,
                ),
              ),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (BuildContext context) => EditProfile()));
              },
            ),
            Center(
                child: Stack(children: [
              Container(
                width: 130,
                height: 130,
                decoration: BoxDecoration(
                  border: Border.all(
                      width: 4,
                      color: Theme.of(context).scaffoldBackgroundColor),
                  boxShadow: [
                    BoxShadow(
                        spreadRadius: 2,
                        blurRadius: 10,
                        color: Colors.black.withOpacity(0.1),
                        offset: Offset(0, 10))
                  ],
                  shape: BoxShape.circle,
                ),
              ),
              Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        width: 4,
                        color: Theme.of(context).scaffoldBackgroundColor,
                      ),
                      color: Colors.blue,
                    ),
                    child: Icon(
                      Icons.edit,
                      color: Colors.white,
                    ),
                  )),
            ])),
            SizedBox(
              height: 50,
            ),
          ]),
        ),
      ),
    );
  }
}
