# Unit tests

This folder mirrors `lib/` so that:

- `test/domain/common/` tests `lib/domain/common/` (filter logic, validators).
- `test/domain/usecases/` tests `lib/domain/usecases/` (data processing use cases).

## Running tests

```bash
flutter test
```

To run a single file:

```bash
flutter test test/domain/common/filter_habits_for_date_test.dart
```

## Adding new unit tests

1. **Place tests next to the code they cover**  
   For `lib/domain/common/foo.dart`, add `test/domain/common/foo_test.dart`.

2. **Use the same grouping style**  
   `group('ClassName.methodOrFunction', () { ... });` and descriptive `test('...', () { ... });` names so others can extend or run a subset.

3. **Keep tests deterministic**  
   Use fixed dates (e.g. `DateTime(2025, 3, 15)`) or inject a `referenceDate` where the production code supports it (e.g. `GetStatisticsUseCase.execute(habits, referenceDate)`).

4. **Shared test data**  
   Use `setUp()` for entities used in multiple tests; consider a `test/fixtures/` or `test/helpers/` folder if you need reusable builders.

Existing tests cover:

- **Filter logic:** `filter_habits_for_date_test.dart` — date filtering, ongoing/completed, sort order.
- **Input validation:** `habit_name_validator_test.dart` — habit name required / trim.
- **Data processing:** `get_statistics_usecase_test.dart` — empty list, best streak, monthly percent, top streaks.
