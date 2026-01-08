# Contributing to Agora

Thank you for your interest in contributing to Agora! We welcome contributions from the community to help make this project better for everyone.

## Development Setup

This project uses [FVM (Flutter Version Management)](https://fvm.app/) to ensure consistent Flutter versions across all developers.

### Prerequisites

1.  **Install FVM**:
    ```bash
    brew tap leoafarias/fvm
    brew install fvm
    ```
    *(For other OS instructions, visit the [FVM documentation](https://fvm.app/docs/getting_started/installation))*

2.  **Install Flutter SDK**:
    Inside the project root, run:
    ```bash
    fvm install
    ```
    This will install the specific Flutter version defined in `.fvmrc`.

3.  **Setup IDE**:
    - **VS Code**: Adding the `.vscode/settings.json` is recommended to point the SDK to `.fvm/flutter_sdk`.
    - **Android Studio**: Configure the Flutter SDK path to `<project-path>/.fvm/flutter_sdk`.

### Running the App

ALWAYS use `fvm` prefix for flutter commands to ensure you are using the correct version.

```bash
fvm flutter pub get
fvm flutter run
```

## Branching Strategy

- We use `main` as the default branch.
- Create feature branches from `main`: `feature/my-new-feature` or `fix/bug-fix`.

## Commit Convention

We follow the [Conventional Commits](https://www.conventionalcommits.org/) specification.

Structure: `<type>[optional scope]: <description>`

Examples:
- `feat(auth): add login screen`
- `fix(cart): resolve item count issue`
- `docs: update readme`
- `chore: bump dependencies`

## Code Style & Linting

We enforce strict linting rules. Before submitting a PR, ensure your code is formatted and analyzed.

```bash
fvm flutter format .
fvm flutter analyze
```

We recommend installing `lefthook` to automatically run these checks before committing.

## Pull Requests

1.  Fork the repository.
2.  Create your feature branch.
3.  Commit your changes following the convention.
4.  Push to the branch.
5.  Open a Pull Request against `main`.
6.  Fill out the Pull Request Template.

## Reporting Issues

Please use the provided Issue Templates for bug reports and feature requests. Provide as much detail as possible.
