import 'dart:async';

import 'package:bloc_exports/bloc_exports.dart';
import 'package:flutter/widgets.dart';
import 'package:feature_reports/domain/models/closing_report.dart';
import 'package:feature_reports/domain/repositories/closing_report_repository.dart';
import 'package:result/result.dart';

part 'closing_report_cubit.freezed.dart';
part 'closing_report_state.dart';

/// Drives the end-of-day cash-closure screen.
///
/// Loads an aggregated [ClosingReport] for today from [ClosingReportRepository]
/// and exposes methods for updating the cash-count field, saving the closure,
/// and streaming the history of past closures.
class ClosingReportCubit extends Cubit<ClosingReportState> {
  ClosingReportCubit({
    required ClosingReportRepository closingReportRepository,
  }) : _repo = closingReportRepository,
       super(const ClosingReportState());

  final ClosingReportRepository _repo;
  StreamSubscription<List<ClosingReport>>? _historySub;

  /// Loads today's aggregated totals and subscribes to the history stream.
  Future<void> load() async {
    emit(state.copyWith(status: ClosingReportStatus.loading, errorMessage: null));

    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day);

    final result = await _repo.buildForPeriod(startOfDay, now);

    switch (result) {
      case Ok<ClosingReport>(:final value):
        _historySub?.cancel();
        _historySub = _repo.watchAll().listen(
          (history) => emit(state.copyWith(history: history)),
          onError: (_) {},
        );
        emit(state.copyWith(status: ClosingReportStatus.ready, currentReport: value));
      case Error<ClosingReport>():
        emit(
          state.copyWith(
            status: ClosingReportStatus.error,
            errorMessage: 'Impossibile caricare i dati. Riprova.',
          ),
        );
    }
  }

  /// Updates the cash-counted amount (typed by the operator into the input field).
  void setCashCounted(int? cents) {
    final report = state.currentReport;
    if (report == null) return;
    emit(
      state.copyWith(currentReport: report.copyWith(cashCountedCents: cents)),
    );
  }

  /// Updates the optional operator note.
  void setNotes(String notes) {
    final report = state.currentReport;
    if (report == null) return;
    emit(
      state.copyWith(
        currentReport: report.copyWith(notes: notes.trim().isEmpty ? null : notes.trim()),
      ),
    );
  }

  /// Persists the current closure to the database.
  Future<void> save() async {
    final report = state.currentReport;
    if (report == null) return;
    emit(state.copyWith(status: ClosingReportStatus.saving));

    final result = await _repo.save(report);
    switch (result) {
      case Ok<ClosingReport>(:final value):
        emit(state.copyWith(status: ClosingReportStatus.saved, currentReport: value));
      case Error<ClosingReport>():
        emit(
          state.copyWith(
            status: ClosingReportStatus.error,
            errorMessage: 'Impossibile salvare la chiusura. Riprova.',
          ),
        );
    }
  }

  @override
  Future<void> close() {
    _historySub?.cancel();
    return super.close();
  }
}

extension ClosingReportCubitExtension on BuildContext {
  ClosingReportCubit get closingReportCubit => read<ClosingReportCubit>();
}
