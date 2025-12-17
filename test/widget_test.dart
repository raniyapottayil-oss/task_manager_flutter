// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.


import 'package:flutter_test/flutter_test.dart';
import 'package:task_manager_flutter/feature/tasks/data/models/task_model.g.dart';
import 'package:task_manager_flutter/main.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() {
  testWidgets('App launches successfully', (WidgetTester tester) async {
    // Initialize Hive for tests
    Hive.init('./test/hive_testing');
    Hive.registerAdapter(TaskModelAdapter());
    await tester.pumpWidget(MyApp());

    // App title should exist
    expect(find.text('Tasks'), findsOneWidget);
  });
}