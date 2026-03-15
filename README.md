# habits_app

A Flutter habit tracking application built with modern best practices.

## Features

### Fullscreen overlay reminders

When a habit reminder fires, the app can show a **fullscreen overlay** so you can complete or dismiss the habit without leaving the flow. The overlay appears:

- When the app is in the **foreground** (e.g. you're using the app at reminder time).
- When you **open the app from a notification** (e.g. tap the reminder while the screen is off or the app is in the background).

The overlay shows the habit’s **icon**, **title**, and **frequency** (e.g. “Daily habit”), and offers **Mark completed** and **Dismiss for now**. Tapping the notification with the screen off will wake the device and open this overlay so you can act on the reminder immediately.

### Statistics screen

The **Statistics** screen (consistency, activity heat map, top streaks, insights) is based on **real data** from your habits and completion history. It is not demo or placeholder content. Metrics are computed from:

- Your habit list and completion dates.
- The current (or test-injected) date for time-based charts.

Use the **W** / **M** toggle to switch between **week** and **month** consistency views.

## Tech Stack

- **Flutter** - UI framework
- **Firebase** - Auth and backend
- **Cloud Firestore** - Database (habits and user data)
- **Riverpod** - State management with annotations and Notifier (see [State Management](#state-management))

## State Management

This project uses **modern Riverpod** with the following approach:

- **Riverpod Annotations**: Uses [`riverpod_annotation`](https://pub.dev/packages/riverpod_annotation) for declarative provider definitions
- **Notifier**: Extends [`Notifier`](https://riverpod.dev/docs/providers/notifier_provider) and [`AutoDisposeNotifier`] for state management
- **Code Generation**: Leverages [`build_runner`](https://pub.dev/packages/build_runner) to generate `.g.dart` files for type-safe providers

### Key Benefits

- **Type-safe**: Full compile-time safety with generated code
- **Testable**: Easy to mock and test providers
- **Scalable**: Clean architecture that scales with project size
- **Auto-dispose**: Automatic cleanup of unused providers

## Getting Started

### Prerequisites

- Flutter SDK (latest stable)
- Dart SDK (latest stable)

### Installation

```bash
flutter pub get
```

### Running the App

```bash
flutter run
```

### Delete Conflicting Outputs

When working with code generation (Riverpod), you may encounter conflicting generated files. To clean and regenerate:

```bash
# Delete all generated files and rebuild
flutter clean
flutter pub get
dart run build_runner build --delete-conflicting-outputs
```

Or in a single command:

```bash
flutter clean && flutter pub get && dart run build_runner build --delete-conflicting-outputs
```

### Code Generation

After modifying provider or model files, regenerate the `.g.dart` files:

```bash
dart run build_runner build --delete-conflicting-outputs
```

For development with watch mode:

```bash
dart run build_runner watch --delete-conflicting-outputs
```

## Unit tests

The project includes unit tests for **filter logic**, **input validation**, and **data processing**. The test folder mirrors `lib/`: e.g. `test/domain/common/` tests `lib/domain/common/`.

### What’s covered

| Area | Test file | What it tests |
|------|-----------|----------------|
| **Filter logic** | `test/domain/common/filter_habits_for_date_test.dart` | Date filtering (daily/weekly), ongoing vs completed, sort order (A–Z / Z–A), date normalization |
| **Input validation** | `test/domain/common/habit_name_validator_test.dart` | Habit name required, trim, null/empty/whitespace |
| **Data processing** | `test/domain/usecases/habit/get_statistics_usecase_test.dart` | Empty habits, best streak, monthly completion %, top streaks order |

### How to run tests

Run all tests:

```bash
flutter test
```

Run a single test file:

```bash
flutter test test/domain/common/filter_habits_for_date_test.dart
```

For conventions on adding new tests and keeping them deterministic, see [test/README.md](test/README.md).

## Project Structure

```
lib/
├── core/           # Constants, themes, DI
├── data/           # Models, repositories
├── domain/         # Entities, use cases
├── presentation/   # Screens, providers, widgets
└── main.dart       # Entry point
```

## Resources

- [Flutter Documentation](https://docs.flutter.dev/)
- [Riverpod 3.0 Documentation](https://riverpod.dev/docs/whats_new)
- [Firebase for Flutter](https://firebase.google.com/docs/flutter/setup)
- [Cloud Firestore](https://firebase.google.com/docs/firestore)
