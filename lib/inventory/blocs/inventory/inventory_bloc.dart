import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:agora/inventory/repositories/inventory_repository.dart';

part 'inventory_bloc.freezed.dart';
part 'inventory_event.dart';
part 'inventory_state.dart';

/// BLoC for managing stock levels with real-time updates.
class InventoryBloc extends Bloc<InventoryEvent, InventoryState> {
  InventoryBloc({
    required InventoryRepository inventoryRepository,
  })  : _inventoryRepository = inventoryRepository,
        super(const InventoryState.initial()) {
    on<_Started>(_onStarted);
    on<_ThresholdChanged>(_onThresholdChanged);
    on<_FilterChanged>(_onFilterChanged);
    on<_Refresh>(_onRefresh);
  }

  final InventoryRepository _inventoryRepository;
  StreamSubscription<List<Stock>>? _stocksSubscription;
  StreamSubscription<List<Stock>>? _lowStocksSubscription;

  // Filter state
  bool _showLowStockOnly = false;
  int _lowStockThreshold = 10;
  List<Stock> _allStocks = [];
  List<Stock> _lowStocks = [];

  // ============================================================
  // EVENT HANDLERS
  // ============================================================

  Future<void> _onStarted(_Started event, Emitter<InventoryState> emit) async {
    emit(const InventoryState.loading());

    await _stocksSubscription?.cancel();
    await _lowStocksSubscription?.cancel();

    // Subscribe to all stocks
    _stocksSubscription = _inventoryRepository.watchAllStocks().listen(
      (stocks) {
        _allStocks = stocks;
        _emitLoaded();
      },
      onError: (error) {
        if (!isClosed) {
          // ignore: invalid_use_of_visible_for_testing_member
          emit(InventoryState.error(
            message: error.toString(),
            previousState:
                state is InventoryLoaded ? state as InventoryLoaded : null,
          ));
        }
      },
    );

    // Subscribe to low stocks
    _lowStocksSubscription =
        _inventoryRepository.watchLowStocks(_lowStockThreshold).listen(
      (stocks) {
        _lowStocks = stocks;
        _emitLoaded();
      },
      onError: (_) {
        // Non-fatal, low stock count will just be 0
      },
    );
  }

  Future<void> _onThresholdChanged(
    _ThresholdChanged event,
    Emitter<InventoryState> emit,
  ) async {
    _lowStockThreshold = event.threshold;

    // Resubscribe to low stocks with new threshold
    await _lowStocksSubscription?.cancel();
    _lowStocksSubscription =
        _inventoryRepository.watchLowStocks(_lowStockThreshold).listen(
      (stocks) {
        _lowStocks = stocks;
        _emitLoaded();
      },
    );

    _emitLoaded();
  }

  Future<void> _onFilterChanged(
    _FilterChanged event,
    Emitter<InventoryState> emit,
  ) async {
    _showLowStockOnly = event.lowStockOnly;
    _emitLoaded();
  }

  Future<void> _onRefresh(_Refresh event, Emitter<InventoryState> emit) async {
    add(const InventoryEvent.started());
  }

  // ============================================================
  // HELPERS
  // ============================================================

  void _emitLoaded() {
    if (isClosed) return;

    final displayStocks = _showLowStockOnly ? _lowStocks : _allStocks;

    // ignore: invalid_use_of_visible_for_testing_member
    emit(InventoryState.loaded(
      stocks: displayStocks,
      lowStockCount: _lowStocks.length,
      threshold: _lowStockThreshold,
      showLowStockOnly: _showLowStockOnly,
    ));
  }

  @override
  Future<void> close() {
    _stocksSubscription?.cancel();
    _lowStocksSubscription?.cancel();
    return super.close();
  }
}

// ============================================================
// CONTEXT EXTENSIONS
// ============================================================

extension InventoryBlocExtension on BuildContext {
  InventoryBloc get inventoryBloc => read<InventoryBloc>();
  InventoryBloc get watchInventoryBloc => watch<InventoryBloc>();
}
