import 'package:mafcode/core/models/report.dart';
import 'package:mafcode/core/network/api.dart';
import 'package:mobx/mobx.dart';

part 'reports_list_store.g.dart';

enum ReportsSource {
  ALL,
  CURRENT_USER,
}

class ReportsListStore = _ReportsListStoreBase with _$ReportsListStore;

abstract class _ReportsListStoreBase with Store {
  final Api _api;
  final ReportsSource reportsSource;

  _ReportsListStoreBase(this._api, this.reportsSource);

  @observable
  ObservableFuture<List<Report>> lastReportsFuture = ObservableFuture.value([]);

  @computed
  List<Report> get lastReports => lastReportsFuture.value;
  @computed
  bool get isLoading => lastReportsFuture.status == FutureStatus.pending;
  @computed
  bool get hasError => lastReportsFuture.status == FutureStatus.rejected;
  @computed
  dynamic get error => lastReportsFuture.error;

  @action
  Future<void> getReports() async {
    switch (reportsSource) {
      case ReportsSource.ALL:
        lastReportsFuture = _api.getAllReports().asObservable();
        break;
      case ReportsSource.CURRENT_USER:
        lastReportsFuture = _api.getCurrentUserReports().asObservable();
        break;
    }
  }
}
