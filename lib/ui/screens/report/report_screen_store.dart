import 'dart:io';

import 'package:mafcode/core/models/report.dart';
import 'package:mafcode/core/network/api.dart';
import 'package:mobx/mobx.dart';
import 'package:no_context_navigation/no_context_navigation.dart';

import '../../auto_router_config.gr.dart';
part 'report_screen_store.g.dart';

class ReportScreenStore = _ReportScreenStoreBase with _$ReportScreenStore;

abstract class _ReportScreenStoreBase with Store {
  final Api _api;

  _ReportScreenStoreBase(this._api);

  @observable
  ObservableFuture<Report> addReportFuture = ObservableFuture.value(null);

  @computed
  bool get isLoading => addReportFuture.status == FutureStatus.pending;
  @computed
  bool get hasError => addReportFuture.status == FutureStatus.rejected;
  @computed
  String get error => addReportFuture.error.toString();

  @action
  Future<void> postNewReport({
    ReportType reportType,
    String name,
    String age,
    String clothings,
    String notes,
    File file,
  }) async {
    addReportFuture = _api
        .createReport(
      reportType,
      Report(
        name: name,
        age: double.parse(age).roundToDouble(),
        clothings: clothings,
        notes: notes,
      ),
      file,
    )
        .then((r) {
      navService.pushReplacementNamed(Routes.matchesScreen,
          args: MatchesScreenArguments(
            reportId: r.id,
          ));
      return r;
    }).asObservable();
  }
}
