import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mafcode/core/di/providers.dart';
import 'package:mafcode/core/models/user_info.dart';
import 'package:mafcode/core/network/api.dart';
import 'package:mafcode/ui/screens/main/profile/editProfile.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:validators/validators.dart';

final profileStateProvider = StateNotifierProvider<ProfileStateNotifer>((ref) {
  return ProfileStateNotifer(ref.read(apiProvider));
});

class ProfileStateNotifer extends StateNotifier<AsyncValue<UserInfo>> {
  final Api api;
  final passwordRegex = RegExp("^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)");

  ProfileStateNotifer(this.api) : super(AsyncValue.loading());

  Future<void> loadUserInfo() async {
    state = AsyncValue.loading();
    state = await AsyncValue.guard<UserInfo>(() => api.getCurrentUserInfo());
  }

  Future<void> uploadUserPhoto(File file) async {
    state = AsyncValue.loading();
    state = await AsyncValue.guard<UserInfo>(() => api.changeCurrentUserPhoto(file));
  }

  String convertImageIdToUrl(String id) {
    return api.getImageUrlFromId(id);
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove("token");
  }

  bool _validatePassword(String password) {
    return isLength(password, 8, 20) && passwordRegex.hasMatch(password);
  }

  Future<EditProfileValidationError> updateUserInfo({
    @required String firstName,
    @required String lastName,
    @required String contact,
    @required String email,
    @required String oldPassword,
    @required String newPassword,
    @required String newPassword2,
  }) async {
    final validationError = EditProfileValidationError();

    // Calc diff
    final currentUserInfo = (state as AsyncData<UserInfo>).value;

    if (firstName == currentUserInfo.firstName) firstName = null;
    if (lastName == currentUserInfo.lastName) lastName = null;
    if (contact == currentUserInfo.contact) contact = null;
    if (email == currentUserInfo.email) email = null;

    if (oldPassword.isEmpty) oldPassword = null;
    if (newPassword.isEmpty) newPassword = null;
    if (newPassword2.isEmpty) newPassword2 = null;

    bool hasError = false;

    if (email != null && !isEmail(email)) {
      hasError = true;
      validationError.email = "Please enter a valid email";
    }

    if (firstName != null && firstName.isEmpty) {
      hasError = true;
      validationError.firstName = "Please enter a first name";
    }

    if (lastName != null && lastName.isEmpty) {
      hasError = true;
      validationError.lastName = "Please enter a last name";
    }

    if (contact != null && contact.isEmpty) {
      hasError = true;
      validationError.contect = "Please enter a contact";
    }

    if (email != null && oldPassword == null) {
      hasError = true;
      validationError.oldPassword = "Changing email require password";
    }

    if (newPassword != null && !_validatePassword(newPassword)) {
      hasError = true;
      validationError.newPassword =
          "Password must be at least 8 chars, & must contain lowerCase & upperCase letters, & numbers";
    }

    if (newPassword != null && newPassword != newPassword2) {
      hasError = true;
      validationError.newPassword2 = "Password doesn't match";
    }

    if (hasError) return validationError;

    state = AsyncValue.loading();

    state = await AsyncValue.guard<UserInfo>(() => api.updateCurrentUserInfo(
          email: email,
          password: oldPassword,
          newPassword: newPassword,
          firstName: firstName,
          lastName: lastName,
          contact: contact,
        ));

    return state.maybeWhen(
      error: (_, __) => validationError,
      orElse: () => null,
    );
  }
}
