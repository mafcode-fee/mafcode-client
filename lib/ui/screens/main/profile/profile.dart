import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mafcode/core/di/providers.dart';
import 'package:mafcode/core/models/user_info.dart';
import 'package:mafcode/core/network/api.dart';
import 'package:mafcode/ui/screens/main/profile/editProfile.dart';
import 'package:mafcode/ui/screens/main/profile/profile_state_notifier.dart';
import 'package:mafcode/ui/shared/dialogs.dart';
import 'package:mafcode/ui/shared/error_utils.dart';
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
          return Center(
            child: Text("Error ${ErrorUtils.getMessage(err)}"),
          );
        },
        data: (userInfo) => buildBody(context, userInfo),
      ),
    );
  }

  Container buildBody(BuildContext context, UserInfo userInfo) {
    return Container(
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
              Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => EditProfile()));
            },
          ),
          buildImage(context, userInfo.photoId),
          SizedBox(
            height: 50,
          ),
        ]),
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
