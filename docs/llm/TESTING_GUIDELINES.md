# Testing guidelines

## Unit tests

- Use `bloc_test` for Bloc/Cubit behavior tests.
- Use `mockito` or `http_mock_adapter` to mock external services (Dio).
- Keep tests fast and deterministic.

## Integration and widget tests

- Limit heavy UI tests; focus on critical flows. Use integration tests sparingly.

## CI expectations for AI-generated patches

- New logic must include unit tests or update existing tests.
- If a change touches persistence or generated code, include the generator command in the PR and include generated files or instruct CI to run generation.

## Running tests locally

flutter test
