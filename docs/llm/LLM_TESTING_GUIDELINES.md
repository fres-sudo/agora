# LLM Testing Guidelines

This document provides rules and guidelines for LLMs to generate tests for this project, following the patterns established in `test/products`.

## General Rules

1.  **Framework**: Use `flutter_test` for all tests.
2.  **Mocking**: Use `mockito` heavily.
    -   Generate mocks using `@GenerateMocks` annotation.
    -   Store generated mocks in a separate file (e.g., `filename.mocks.dart`) if the file is large, or rely on `build_runner`.
    -   Run `fvm dart run build_runner build --delete-conflicting-outputs` to generate mocks.
3.  **Directory Structure**: Mirror the `lib` structure within `test`.
    -   `lib/feature/repositories/` -> `test/feature/repositories/`
    -   `lib/feature/blocs/my_bloc/` -> `test/feature/blocs/my_bloc/`
4.  **Naming Conventions**:
    -   Test files: `[filename]_test.dart`
    -   Mocks file: `[filename]_test.mocks.dart` (generated)

## Repository Testing Patterns

Tests for repositories should verify that the repository correctly interacts with its dependencies (usually DAOs or API clients).

### Setup
1.  **Dependencies**: Mock all dependencies (e.g., DAOs).
2.  **Subject**: Instantiate the real implementation of the repository with the mocked dependencies.
3.  **Lifecycle**: Use `setUp` to reset mocks and re-instantiate the repository before each test.

### Test Structure
-   Use `group` to organize tests by class or functionality.
-   **Streams/Watchers**:
    -   Mock the DAO stream using `when(...).thenAnswer((_) => Stream.value(...))`.
    -   Subscribe to the repository stream and verify the first emitted value.
    -   Verify the DAO method was called.
-   **Futures/Actions** (Create, Update, Delete):
    -   Mock the DAO response using `when(...).thenAnswer(...)`.
    -   Call the repository method.
    -   Expect the result (e.g., `Result.ok` or specific value).
    -   Verify the DAO method was called using `verify(...).called(1)`.

### Example Template
```dart
@GenerateMocks([MyDao])
void main() {
  late MockMyDao mockMyDao;
  late MyRepositoryImpl repository;

  setUp(() {
    mockMyDao = MockMyDao();
    repository = MyRepositoryImpl(myDao: mockMyDao);
  });

  group('MyRepositoryImpl', () {
    test('method calls dao and returns result', () async {
      // Arrange
      when(mockMyDao.getData()).thenAnswer((_) async => 'data');

      // Act
      final result = await repository.getData();

      // Assert
      expect(result, 'data');
      verify(mockMyDao.getData()).called(1);
    });
  });
}
```

## BLoC Testing Patterns

Tests for BLoCs should verify state changes in response to events.

### Setup
1.  **Dependencies**: Mock all repositories or services the BLoC depends on.
2.  **Subject**: The BLoC instance itself.
3.  **Lifecycle**:
    -   `setUp`: Initialize mocks and the BLoC.
    -   `tearDown`: Close the BLoC.

### Test Structure
-   **Initial State**: Verify `bloc.state` matches the expected initial state.
-   **BlocTest**: Use `blocTest` from `package:bloc_test`.
    -   `build`: Return the BLoC instance.
    -   `setUp`: Configure mock responses for any calls the BLoC makes during the event handler.
    -   `act`: Add events to the BLoC.
    -   `expect`: Return a list of expected states in order.
    -   `verify` (Optional): Verify side effects (e.g., repository calls) if they are not fully captured by state changes.

### Tips
-   **Debounce/Async**: If the BLoC has debouncing or async gaps, use `wait` or `Future.delayed` within `act` if necessary, though `blocTest` usually handles simple async well.
-   **Streams**: If the BLoC subscribes to a stream (e.g. `started` event), mock the stream in `setUp`.

### Example Template
```dart
@GenerateMocks([MyRepository])
void main() {
  late MockMyRepository mockRepository;
  late MyBloc bloc;

  setUp(() {
    mockRepository = MockMyRepository();
    bloc = MyBloc(repository: mockRepository);
  });

  tearDown(() {
    bloc.close();
  });

  blocTest<MyBloc, MyState>(
    'emits [loading, loaded] when Started is added',
    setUp: () {
      when(mockRepository.getData()).thenAnswer((_) async => 'data');
    },
    build: () => bloc,
    act: (bloc) => bloc.add(const MyEvent.started()),
    expect: () => [
      const MyState.loading(),
      const MyState.loaded('data'),
    ],
  );
}
```
