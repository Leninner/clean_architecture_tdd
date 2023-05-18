import 'package:clean_architecture_tdd/features/number_trivia/presentation/widgets/trivia_controls.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('NumberTriviaPage tests', () {
    group('When render', () {
      testWidgets('should display a placeholder message',
          (WidgetTester tester) async {
        await tester.pumpWidget(MaterialApp(
          home: Scaffold(body: TriviaControls()),
        ));

        expect(find.text('Input a number'), findsOneWidget);
      });
    });
  });
}
