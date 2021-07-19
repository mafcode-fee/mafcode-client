import 'dart:io';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mafcode/core/di/providers.dart';
import 'package:mafcode/core/models/user_info.dart';
import 'package:mafcode/core/network/api.dart';
import 'package:shared_preferences/shared_preferences.dart';

final profileStateProvider = StateNotifierProvider<ProfileStateNotifer>((ref) {
  return ProfileStateNotifer(ref.read(apiProvider));
});

class ProfileStateNotifer extends StateNotifier<AsyncValue<UserInfo>> {
  final Api api;

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
}
