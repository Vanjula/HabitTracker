import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_app_proj/main.dart';  // Make sure the correct app file is imported

void main() {
  testWidgets('Add habit smoke test', (WidgetTester tester) async {
    // Build the HabitTracker app and trigger a frame.
    await tester.pumpWidget(HabitTrackerApp());

    // Verify that no habits are present initially.
    expect(find.text('No habits added.'), findsOneWidget);

    // Enter a new habit in the text field.
    await tester.enterText(find.byType(TextField), 'Exercise');
    
    // Tap the 'Add' button.
    await tester.tap(find.text('Add'));
    
    // Rebuild the widget after the state has changed.
    await tester.pump();

    // Verify that the habit has been added.
    expect(find.text('Exercise'), findsOneWidget);
    expect(find.text('No habits added.'), findsNothing);
  });
}
