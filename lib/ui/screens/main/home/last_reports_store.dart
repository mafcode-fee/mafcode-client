import 'package:mafcode/core/models/report.dart';
import 'package:mafcode/core/network/api.dart';
import 'package:mobx/mobx.dart';
part 'last_reports_store.g.dart';

class LastReportsStore = _LastReportsStoreBase with _$LastReportsStore;

abstract class _LastReportsStoreBase with Store {
  final Api _api;

  _LastReportsStoreBase(this._api);

  @observable
  ObservableFuture<List<Report>> lastReportsFuture = ObservableFuture.value([]);

  @computed
  List<Report> get lastReports => lastReportsFuture.value;
  @computed
  bool get isLoading => lastReportsFuture.status == FutureStatus.pending;
  @computed
  bool get hasError => lastReportsFuture.status == FutureStatus.rejected;
  @computed
  String get error => lastReportsFuture.error.toString();

  @action
  void getLastReports() {
    lastReportsFuture = _api.getAllReports().asObservable();
  }
}
