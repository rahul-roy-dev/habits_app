# habits_app

A Flutter habit tracking application built with modern best practices.

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
