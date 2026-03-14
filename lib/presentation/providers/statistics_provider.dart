import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:habits_app/domain/entities/statistics_result.dart';
import 'dependency_providers.dart';
import 'habit_provider.dart';

part 'statistics_provider.g.dart';

@riverpod
StatisticsResult statistics(Ref ref) {
  final habits = ref.watch(habitProvider).habits;
  return ref.read(getStatisticsUseCaseProvider).execute(habits);
}
