import 'package:flutter/foundation.dart';
import 'package:agora/core/ui/widgets/data_table/data_table_config.dart';

/// Controller for managing the state of a DataTableView.
///
/// This controller handles search, sorting, filtering, pagination,
/// and selection state for the data table.
class DataTableController<T> extends ChangeNotifier {
  DataTableController({
    int rowsPerPage = 10,
    SortOption? initialSort,
  })  : _rowsPerPage = rowsPerPage,
        _currentSort = initialSort;

  // Search
  String _searchQuery = '';
  String get searchQuery => _searchQuery;
  set searchQuery(String value) {
    if (_searchQuery != value) {
      _searchQuery = value;
      _currentPage = 0; // Reset to first page on search
      notifyListeners();
    }
  }

  // Sorting
  SortOption? _currentSort;
  SortOption? get currentSort => _currentSort;
  set currentSort(SortOption? value) {
    if (_currentSort != value) {
      _currentSort = value;
      notifyListeners();
    }
  }

  // Filters
  Map<String, dynamic> _filters = {};
  Map<String, dynamic> get filters => Map.unmodifiable(_filters);

  void setFilter(String key, dynamic value) {
    _filters[key] = value;
    _currentPage = 0; // Reset to first page on filter change
    notifyListeners();
  }

  void removeFilter(String key) {
    _filters.remove(key);
    _currentPage = 0;
    notifyListeners();
  }

  void clearFilters() {
    _filters.clear();
    _currentPage = 0;
    notifyListeners();
  }

  void applyFilters(Map<String, dynamic> newFilters) {
    _filters = Map.from(newFilters);
    _currentPage = 0;
    notifyListeners();
  }

  bool get hasActiveFilters => _filters.isNotEmpty;

  // Pagination
  int _currentPage = 0;
  int get currentPage => _currentPage;
  set currentPage(int value) {
    if (_currentPage != value && value >= 0) {
      _currentPage = value;
      notifyListeners();
    }
  }

  int _rowsPerPage;
  int get rowsPerPage => _rowsPerPage;
  set rowsPerPage(int value) {
    if (_rowsPerPage != value && value > 0) {
      _rowsPerPage = value;
      _currentPage = 0; // Reset to first page
      notifyListeners();
    }
  }

  int _totalItems = 0;
  int get totalItems => _totalItems;
  set totalItems(int value) {
    if (_totalItems != value) {
      _totalItems = value;
      // Adjust current page if it's now out of bounds
      final maxPage = totalPages - 1;
      if (_currentPage > maxPage && maxPage >= 0) {
        _currentPage = maxPage;
      }
      notifyListeners();
    }
  }

  int get totalPages => (_totalItems / _rowsPerPage).ceil();

  bool get hasNextPage => _currentPage < totalPages - 1;
  bool get hasPreviousPage => _currentPage > 0;

  void nextPage() {
    if (hasNextPage) {
      _currentPage++;
      notifyListeners();
    }
  }

  void previousPage() {
    if (hasPreviousPage) {
      _currentPage--;
      notifyListeners();
    }
  }

  void goToPage(int page) {
    if (page >= 0 && page < totalPages && page != _currentPage) {
      _currentPage = page;
      notifyListeners();
    }
  }

  // Selection (for action mode / batch operations)
  final Set<T> _selectedItems = {};
  Set<T> get selectedItems => Set.unmodifiable(_selectedItems);
  bool get hasSelection => _selectedItems.isNotEmpty;
  int get selectionCount => _selectedItems.length;

  bool isSelected(T item) => _selectedItems.contains(item);

  void select(T item) {
    _selectedItems.add(item);
    notifyListeners();
  }

  void deselect(T item) {
    _selectedItems.remove(item);
    notifyListeners();
  }

  void toggleSelection(T item) {
    if (_selectedItems.contains(item)) {
      _selectedItems.remove(item);
    } else {
      _selectedItems.add(item);
    }
    notifyListeners();
  }

  void selectAll(List<T> items) {
    _selectedItems.addAll(items);
    notifyListeners();
  }

  void clearSelection() {
    _selectedItems.clear();
    notifyListeners();
  }

  // Loading state
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  set isLoading(bool value) {
    if (_isLoading != value) {
      _isLoading = value;
      notifyListeners();
    }
  }

  /// Resets all state to initial values.
  void reset() {
    _searchQuery = '';
    _currentSort = null;
    _filters.clear();
    _currentPage = 0;
    _selectedItems.clear();
    _isLoading = false;
    notifyListeners();
  }
}
