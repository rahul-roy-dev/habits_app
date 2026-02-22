import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:habits_app/domain/entities/habit_entity.dart';
import 'package:habits_app/domain/repositories/habit/i_habit_repository.dart';

/// Firestore implementation of [IHabitRepository].
class FirestoreHabitRepository implements IHabitRepository {
  FirestoreHabitRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;
  static const String _collection = 'habits';

  @override
  Future<void> init() async {}

  Map<String, dynamic> _toMap(HabitEntity entity) {
    return {
      'id': entity.id,
      'title': entity.title,
      'description': entity.description,
      'isCompleted': entity.isCompleted,
      'createdAt': Timestamp.fromDate(entity.createdAt),
      'icon': entity.icon,
      'color': entity.color,
      'completionDates': entity.completionDates
          .map((d) => Timestamp.fromDate(DateTime(d.year, d.month, d.day)))
          .toList(),
      'userId': entity.userId,
    };
  }

  HabitEntity _fromMap(Map<String, dynamic> map, String id) {
    final completionDates = (map['completionDates'] as List<dynamic>?)
            ?.map((e) => (e as Timestamp).toDate())
            .toList() ??
        [];
    return HabitEntity(
      id: id,
      title: map['title'] as String? ?? '',
      description: map['description'] as String? ?? '',
      isCompleted: map['isCompleted'] as bool? ?? false,
      createdAt: (map['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      icon: map['icon'] as String? ?? 'water',
      color: map['color'] as int? ?? 0xFFA78BFA,
      completionDates: completionDates,
      userId: map['userId'] as String? ?? '',
    );
  }

  @override
  Future<List<HabitEntity>> getHabitsForUser(String userId) async {
    final snapshot = await _firestore
        .collection(_collection)
        .where('userId', isEqualTo: userId)
        .get();
    final list = snapshot.docs
        .map((doc) => _fromMap(doc.data(), doc.id))
        .toList();
    list.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return list;
  }

  @override
  Future<HabitEntity?> getHabitById(String habitId) async {
    final doc = await _firestore.collection(_collection).doc(habitId).get();
    if (!doc.exists || doc.data() == null) return null;
    return _fromMap(doc.data()!, doc.id);
  }

  @override
  Future<void> addHabit(HabitEntity habit) async {
    await _firestore
        .collection(_collection)
        .doc(habit.id)
        .set(_toMap(habit));
  }

  @override
  Future<void> updateHabit(String habitId, HabitEntity habit) async {
    await _firestore
        .collection(_collection)
        .doc(habitId)
        .set(_toMap(habit), SetOptions(merge: true));
  }

  @override
  Future<void> deleteHabit(HabitEntity habit) async {
    await _firestore.collection(_collection).doc(habit.id).delete();
  }

  @override
  Future<void> toggleHabitCompletion(HabitEntity habit, DateTime date) async {
    final docRef = _firestore.collection(_collection).doc(habit.id);
    final doc = await docRef.get();
    if (!doc.exists || doc.data() == null) return;

    final entity = _fromMap(doc.data()!, doc.id);
    final normalizedDate = DateTime(date.year, date.month, date.day);
    final completionDates = List<DateTime>.from(entity.completionDates);
    final alreadyCompleted = completionDates.any(
      (d) =>
          d.year == normalizedDate.year &&
          d.month == normalizedDate.month &&
          d.day == normalizedDate.day,
    );

    if (alreadyCompleted) {
      completionDates.removeWhere(
        (d) =>
            d.year == normalizedDate.year &&
            d.month == normalizedDate.month &&
            d.day == normalizedDate.day,
      );
    } else {
      completionDates.add(normalizedDate);
    }

    await docRef.update({
      'completionDates': completionDates
          .map((d) => Timestamp.fromDate(DateTime(d.year, d.month, d.day)))
          .toList(),
      'isCompleted': completionDates.isNotEmpty,
    });
  }

  @override
  bool isCompletedOnDate(HabitEntity habit, DateTime date) {
    return habit.isCompletedOnDate(date);
  }
}
