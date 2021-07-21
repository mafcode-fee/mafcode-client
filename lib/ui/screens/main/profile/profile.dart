import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mafcode/core/models/user_info.dart';
import 'package:mafcode/ui/auto_router_config.gr.dart';
import 'package:mafcode/ui/screens/main/home/reports_list_store.dart';
import 'package:mafcode/ui/screens/main/home/reports_list_widget.dart';
import 'package:mafcode/ui/screens/main/profile/profile_state_notifier.dart';
import 'package:mafcode/ui/shared/dialogs.dart';
import 'package:mafcode/ui/shared/error_widget.dart';
import 'package:mafcode/ui/shared/network_image_widget.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class Profile extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final notifer = useProvider(profileStateProvider);
    final state = useProvider(profileStateProvider.state);
    useMemoized(() {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        notifer.loadUserInfo();
      });
    });
    return Scaffold(
      body: state.when(
        loading: () => Center(
          child: CircularProgressIndicator(),
        ),
        error: (err, stk) {
          debugPrintStack(label: err.toString(), stackTrace: stk);
          return MafcodeErrorWidget(
            err,
            onReload: () => notifer.loadUserInfo(),
            extraWidgets: [buildLogoutButton(notifer, context)],
          );
        },
        data: (userInfo) => buildBody(context, userInfo),
      ),
    );
  }

  Container buildBody(BuildContext context, UserInfo userInfo) {
    final notifier = context.read(profileStateProvider);
    return Container(
      padding: EdgeInsets.only(left: 16, right: 16),
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: ListView(
          children: [
            SizedBox(
              height: 50,
            ),
            Row(
              children: [
                buildImage(context, userInfo.photoId),
                SizedBox(width: 20),
                Column(
                  children: [
                    Text(
                      "${userInfo.firstName} ${userInfo.lastName}",
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 20,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "${userInfo.email}",
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xff989cb6),
                      ),
                    ),
                  ],
                )
              ],
            ),
            SizedBox(
              height: 20,
            ),
            ListTile(
              leading: Icon(Icons.phone),
              title: Text("Contact"),
              subtitle: Text(userInfo.contact),
            ),
            Divider(),
            OutlinedButton(
              onPressed: () {
                Navigator.of(context).pushNamed(Routes.editProfile);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.edit),
                  SizedBox(width: 10),
                  Text("Edit Profile"),
                ],
              ),
            ),
            buildLogoutButton(notifier, context),
            Divider(),
            ReportsListWidget(
              title: "My Reports",
              reportsSource: ReportsSource.CURRENT_USER,
            )
          ],
        ),
      ),
    );
  }

  Widget buildLogoutButton(ProfileStateNotifer notifier, BuildContext context) {
    return OutlinedButton(
      onPressed: () async {
        await notifier.logout();
        Navigator.of(context).pushNamedAndRemoveUntil(Routes.loginScreen, (route) => false);
      },
      style: OutlinedButton.styleFrom(
        primary: Colors.red,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.exit_to_app),
          SizedBox(width: 10),
          Text("Sign out"),
        ],
      ),
    );
  }

  Widget buildImage(BuildContext context, String imageId) {
    final notifier = context.read(profileStateProvider);
    Widget image;

    if (imageId == null) {
      image = Icon(
        MdiIcons.imageOff,
        size: 75,
        color: Colors.grey,
      );
    } else {
      final imageUrl = notifier.convertImageIdToUrl(imageId);
      image = NetworkImageWidget(imageUrl);
    }

    return Center(
      child: Stack(
        children: [
          Container(
            width: 130,
            height: 130,
            decoration: BoxDecoration(
              border: Border.all(width: 4, color: Theme.of(context).scaffoldBackgroundColor),
              boxShadow: [
                BoxShadow(spreadRadius: 2, blurRadius: 10, color: Colors.black.withOpacity(0.1), offset: Offset(0, 10))
              ],
              shape: BoxShape.circle,
            ),
            clipBehavior: Clip.antiAlias,
            child: image,
          ),
          Positioned(
              bottom: 0,
              right: 0,
              child: GestureDetector(
                onTap: () async {
                  final selectedFile = await showImagePickerDialog(context);
                  if (selectedFile == null) return;
                  notifier.uploadUserPhoto(selectedFile);
                },
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
                ),
              )),
        ],
      ),
    );
  }
}
