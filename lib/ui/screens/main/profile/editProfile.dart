import 'package:flutter/material.dart';
import 'package:mafcode/ui/screens/main/profile/profile.dart';
import 'package:mafcode/ui/shared/widget_utils.dart';

class EditProfile extends StatefulWidget {
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  bool showPassword = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 1,
        title: Text(
          "Change User Information",
          style: TextStyle(color: Theme.of(context).primaryColor),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.blue,
          ),
          onPressed: () {
            Navigator.of(context).pop(MaterialPageRoute(builder: (BuildContext context) => Profile()));
          },
        ),
      ),
      body: Container(
        padding: EdgeInsets.only(left: 16, right: 16),
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: ListView(
            children: [
              Center(
                child: Text(
                  "User Information",
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
                ),
              ),
              SizedBox(
                height: 50,
              ),
              buildTextField("First Name", false),
              buildTextField("Last Name", false),
              buildTextField("Contact", false),
              Text(
                'User Credentials',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
              ),
              SizedBox(
                height: 35,
              ),
              buildTextField("Email", false),
              buildTextField("Enter Current Password", true),
              buildTextField("Enter New Password", true),
              buildTextField("Re-Type New Password", true),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  OutlinedButton(
                    style: ButtonStyle(
                      padding: EdgeInsets.symmetric(horizontal: 50).asAllMaterialStateProperty(),
                      shape:
                          RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)).asAllMaterialStateProperty(),
                    ),
                    onPressed: () {},
                    child: Text("CANCEL", style: TextStyle(fontSize: 14, letterSpacing: 2.2, color: Colors.black)),
                  ),
                  ElevatedButton(
                    onPressed: () {},
                    style: ButtonStyle(
                      backgroundColor: Colors.blue.asAllMaterialStateProperty(),
                      padding: EdgeInsets.symmetric(horizontal: 50).asAllMaterialStateProperty(),
                      elevation: 2.0.asAllMaterialStateProperty(),
                      shape:
                          RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)).asAllMaterialStateProperty(),
                    ),
                    child: Text(
                      "SAVE",
                      style: TextStyle(fontSize: 14, letterSpacing: 2.2, color: Colors.white),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTextField(String labelText, bool isPasswordTextField) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 35.0),
      child: TextField(
        obscureText: isPasswordTextField ? showPassword : false,
        decoration: InputDecoration(
          suffixIcon: isPasswordTextField
              ? IconButton(
                  onPressed: () {
                    setState(() {
                      showPassword = !showPassword;
                    });
                  },
                  icon: Icon(
                    Icons.remove_red_eye,
                    color: Colors.grey,
                  ),
                )
              : null,
          contentPadding: EdgeInsets.only(bottom: 3),
          labelText: labelText,
        ),
      ),
    );
  }
}
