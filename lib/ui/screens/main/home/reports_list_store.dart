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
  List<Report> get lastReports => lastReportsFuture.value?.reversed?.toList();
  @computed
  bool get isLoading => lastReportsFuture.status == FutureStatus.pending;
  @computed
  bool get hasError => lastReportsFuture.status == FutureStatus.rejected;
  @computed
  dynamic get error => lastReportsFuture.error;

  bool get shouldShowDeleteButton => reportsSource == ReportsSource.CURRENT_USER;

  Future<List<Report>> _getReportFut() {
    switch (reportsSource) {
      case ReportsSource.ALL:
        return _api.getAllReports().asObservable();
        break;
      case ReportsSource.CURRENT_USER:
        return _api.getCurrentUserReports().asObservable();
        break;
    }
  }

  @action
  Future<void> getReports() async {
    lastReportsFuture = _getReportFut().asObservable();
  }

  @action
  Future<void> deleteReport(Report report) async {
    lastReportsFuture = _api.removeReport(report.id).then((value) => _getReportFut()).asObservable();
  }
}
