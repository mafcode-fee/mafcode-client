import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mafcode/ui/screens/main/profile/profile.dart';
import 'package:mafcode/ui/screens/main/profile/profile_state_notifier.dart';
import 'package:mafcode/ui/shared/error_utils.dart';
import 'package:mafcode/ui/shared/widget_utils.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class EditProfileValidationError {
  String firstName;
  String lastName;
  String contect;
  String email;
  String oldPassword;
  String newPassword;
  String newPassword2;

  EditProfileValidationError({
    this.firstName,
    this.lastName,
    this.contect,
    this.email,
    this.oldPassword,
    this.newPassword,
    this.newPassword2,
  });
}

class EditProfile extends StatefulHookWidget {
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  bool showPassword = false;
  @override
  Widget build(BuildContext context) {
    final firstNameController = useTextEditingController();
    final lastNameController = useTextEditingController();
    final contactController = useTextEditingController();
    final emailController = useTextEditingController();
    final oldPasswordController = useTextEditingController();
    final newPasswordController = useTextEditingController();
    final newPassword2Controller = useTextEditingController();

    final validationError = useState<EditProfileValidationError>(null);

    final notifer = useProvider(profileStateProvider);
    final state = useProvider(profileStateProvider.state);

    useEffect(
      () {
        state.whenData((value) {
          emailController.text = value.email;
          firstNameController.text = value.firstName;
          lastNameController.text = value.lastName;
          contactController.text = value.contact;
        });
        return null;
      },
      [state],
    );

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
      body: state.when(
        loading: () => Center(
          child: CircularProgressIndicator(),
        ),
        error: (err, stk) {
          debugPrintStack(label: err.toString(), stackTrace: stk);
          return Center(
            child: Text("Error ${ErrorUtils.getMessage(err)}"),
          );
        },
        data: (userInfo) => Container(
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
                buildTextField(
                  controller: firstNameController,
                  labelText: "First Name",
                  icon: Icons.person,
                  error: validationError.value?.firstName,
                ),
                buildTextField(
                  controller: lastNameController,
                  labelText: "Last Name",
                  icon: Icons.person,
                  error: validationError.value?.lastName,
                ),
                buildTextField(
                  controller: contactController,
                  labelText: "Contact",
                  icon: Icons.phone,
                  error: validationError.value?.contect,
                ),
                Text(
                  'User Credentials',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
                ),
                SizedBox(
                  height: 35,
                ),
                buildTextField(
                  controller: emailController,
                  labelText: "Email",
                  icon: Icons.email,
                  error: validationError.value?.email,
                ),
                buildTextField(
                  controller: oldPasswordController,
                  labelText: "Enter Current Password",
                  isPasswordTextField: true,
                  icon: Icons.lock,
                  error: validationError.value?.oldPassword,
                ),
                buildTextField(
                  controller: newPasswordController,
                  labelText: "Enter New Password",
                  isPasswordTextField: true,
                  icon: Icons.lock,
                  error: validationError.value?.newPassword,
                ),
                buildTextField(
                  controller: newPassword2Controller,
                  labelText: "Re-Type New Password",
                  isPasswordTextField: true,
                  icon: Icons.lock,
                  error: validationError.value?.newPassword2,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    OutlinedButton(
                      style: ButtonStyle(
                        padding: EdgeInsets.symmetric(horizontal: 50).asAllMaterialStateProperty(),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))
                            .asAllMaterialStateProperty(),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text("CANCEL", style: TextStyle(fontSize: 14, letterSpacing: 2.2, color: Colors.black)),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        final error = await notifer.updateUserInfo(
                            firstName: firstNameController.text,
                            lastName: lastNameController.text,
                            contact: contactController.text,
                            email: emailController.text,
                            oldPassword: oldPasswordController.text,
                            newPassword: newPasswordController.text,
                            newPassword2: newPassword2Controller.text);

                        validationError.value = error;
                      },
                      style: ButtonStyle(
                        backgroundColor: Colors.blue.asAllMaterialStateProperty(),
                        padding: EdgeInsets.symmetric(horizontal: 50).asAllMaterialStateProperty(),
                        elevation: 2.0.asAllMaterialStateProperty(),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))
                            .asAllMaterialStateProperty(),
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
      ),
    );
  }

  Widget buildTextField({
    TextEditingController controller,
    String labelText,
    bool isPasswordTextField = false,
    IconData icon,
    String error,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 35.0),
      child: TextField(
        controller: controller,
        obscureText: isPasswordTextField ? showPassword : false,
        decoration: InputDecoration(
          errorText: error,
          prefixIcon: icon == null ? null : Icon(icon),
          suffixIcon: isPasswordTextField
              ? IconButton(
                  onPressed: () {
                    setState(() {
                      showPassword = !showPassword;
                    });
                  },
                  icon: Icon(
                    showPassword ? MdiIcons.eyeOff : MdiIcons.eye,
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
