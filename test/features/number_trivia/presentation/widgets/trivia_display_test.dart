import 'package:clean_architecture_tdd/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:clean_architecture_tdd/features/number_trivia/presentation/widgets/trivia_display.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('TriviaDisplay tests', () {
    const tNumberTrivia = NumberTrivia(text: 'test number', number: 78);

    testWidgets('should show the searched number', (widgetTester) async {
      // arrange
      await widgetTester
          .pumpWidget(const TriviaDisplay(numberTrivia: tNumberTrivia));

      // assert
      final numberText = find.text('78');
      expect(numberText, findsOneWidget);
    });

    testWidgets('should show the searched text', (widgetTester) async {
      // arrange
      await widgetTester
          .pumpWidget(const TriviaDisplay(numberTrivia: tNumberTrivia));

      // assert
      final textText = find.text('test number');
      expect(textText, findsOneWidget);
    });
  });
}
