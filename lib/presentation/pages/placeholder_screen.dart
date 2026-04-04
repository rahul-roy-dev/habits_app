import 'package:flutter/material.dart';
import 'package:habits_app/presentation/widgets/common/habits_app_bar.dart';

class PlaceholderScreen extends StatelessWidget {
  final String title;
  const PlaceholderScreen({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HabitsAppBar(title: title),
      body: Center(child: Text('Coming Soon: $title')),
    );
  }
}
