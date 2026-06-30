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

### Verified build & run loop (festival POS)

The following sequence is the exact, verified loop for getting the Agora
festival POS building, generating, and running from a clean checkout. It uses
[Melos](https://melos.invertase.dev/) to drive the monorepo. The canonical
Melos config lives in the root `pubspec.yaml` (under the `melos:` key); the
`melos.yaml` file is kept for reference only.

1.  **Toolchain** — install FVM and the pinned Flutter SDK:
    ```bash
    brew tap leoafarias/fvm && brew install fvm
    fvm install 3.38.5      # the version pinned in .fvmrc
    fvm use 3.38.5          # creates the .fvm/flutter_sdk symlink Melos needs
    ```
    Melos reads `sdkPath: .fvm/flutter_sdk` from `pubspec.yaml`, so the
    `.fvm/flutter_sdk` symlink **must** exist (created by `fvm use`) or every
    `melos` command fails with "SDK path is not valid".

2.  **Run Melos through FVM** to guarantee an SDK-compatible Melos and avoid the
    globally-activated Melos kernel-mismatch error
    (`Can't load Kernel binary: Invalid kernel binary format version`):
    ```bash
    fvm dart run melos <command>
    ```

3.  **Bootstrap** — link all workspace packages and run `pub get`:
    ```bash
    fvm dart run melos bootstrap
    ```

4.  **Code generation** — run `build_runner` across all packages. Pass
    `--no-select` so the script targets every package non-interactively (without
    it, Melos prompts for a package and fails in non-TTY shells):
    ```bash
    fvm dart run melos run build --no-select
    ```
    > If a single package needs regenerating (faster), run it directly:
    > ```bash
    > cd packages/database && fvm dart run build_runner build --delete-conflicting-outputs
    > ```
    > Note: `fvm flutter pub run build_runner ...` does **not** work for packages
    > that don't declare `build_runner` as an immediate dependency — use
    > `fvm dart run build_runner ...` from the package directory instead, which
    > resolves the shared tool through the pub workspace.

5.  **Lint** (must be clean):
    ```bash
    fvm dart run melos run lint
    ```

6.  **Test** — record the baseline. Melos only runs tests for packages it
    detects under `apps/**`, `features/**`, `packages/**` that contain a `test/`
    dir; pass `--no-select`:
    ```bash
    fvm dart run melos run test --no-select
    ```
    The feature/integration tests currently live in the repo-root `test/`
    directory (which belongs to the `agora_workspace` root package and is **not**
    picked up by `melos run test`). Run them directly:
    ```bash
    fvm flutter test            # from the repo root
    ```

7.  **Run the app**:
    ```bash
    cd apps/agora && fvm flutter run
    ```
    The app currently ships `android`, `ios`, and `web` platform folders (no
    `macos`). To smoke-test a build without a device, a web build compiles the
    whole app end-to-end:
    ```bash
    cd apps/agora && fvm flutter build web
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
