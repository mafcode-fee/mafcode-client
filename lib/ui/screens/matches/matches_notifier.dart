import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mafcode/core/di/providers.dart';
import 'package:mafcode/core/models/report.dart';
import 'package:mafcode/core/network/api.dart';

final matchesNotifierProvider = StateNotifierProvider<MatchesNotifier>((ref) {
  return MatchesNotifier(ref.read(apiProvider));
});

class MatchesNotifier extends StateNotifier<AsyncValue<List<Report>>> {
  final Api api;

  MatchesNotifier(this.api) : super(AsyncValue.loading());

  Future<void> findMatches(String reportId) async {
    state = AsyncValue.loading();

    state = await AsyncValue.guard(() => api.getmatchingReports(reportId));
  }
}
