import 'package:clean_architecture_tdd/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';
import 'package:clean_architecture_tdd/features/number_trivia/presentation/widgets/trivia_controls.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../../utils/widget_setup.dart';
import 'trivia_controls_test.mocks.dart';

@GenerateNiceMocks([MockSpec<NumberTriviaBloc>(as: #NumberTriviaBlocMock)])
void main() {
  late NumberTriviaBlocMock numberTriviaBlocMock = NumberTriviaBlocMock();

  setUpRenderer() {
    return MaterialApp(
      home: Scaffold(body: TriviaControls()),
    );
  }

  setUp(() {
    when(numberTriviaBlocMock.state).thenReturn(Empty());
  });

  group('NumberTriviaPage tests', () {
    group('When render', () {
      testWidgets('should display a placeholder message',
          (WidgetTester tester) async {
        await tester.pumpWidget(setUpRenderer());

        expect(find.text('Input a number'), findsOneWidget);
      });

      testWidgets(
          'should display two buttons, with "Search" and "Get random trivia" field',
          (tester) async {
        await tester.pumpWidget(setUpRenderer());

        expect(find.text('Search'), findsOneWidget);
        expect(find.text('Get random trivia'), findsOneWidget);
      });
    });

    group('When the user typed a word', () {
      testWidgets('should display the word in the concrete search field',
          (WidgetTester tester) async {
        // assert
        await tester.pumpWidget(setUpRenderer());

        // act
        await tester.enterText(
            find.byKey(
              const Key('concrete_search_field'),
            ),
            'test');

        // assert
        expect(find.text('test'), findsOneWidget);
      });
    });

    group('When a word is typed and the user press the Search button', () {
      testWidgets('should dispatch a ConcreteNumberTrivia event',
          (WidgetTester tester) async {
        when(numberTriviaBlocMock.state).thenReturn(Loading());
        // arrange
        await tester.pumpWidget(widgetSetUpWithBloc<NumberTriviaBloc>(
          numberTriviaBlocMock,
          TriviaControls(),
        ));

        await tester.enterText(
            find.byKey(
              const Key('concrete_search_field'),
            ),
            'test');

        // act
        await tester.tap(find.text('Search'));
        await tester.pump();

        // assert
        verify(numberTriviaBlocMock.add(GetTriviaForConcreteNumber('test')));
        expect(find.text('test'), findsOneWidget);
      });
    });

    group('When the user press the Get random trivia button', () {
      testWidgets('should dispatch a GetTriviaForRandomNumber event',
          (WidgetTester tester) async {
        when(numberTriviaBlocMock.state).thenReturn(Loading());
        // arrange
        await tester.pumpWidget(widgetSetUpWithBloc<NumberTriviaBloc>(
          numberTriviaBlocMock,
          TriviaControls(),
        ));

        // act
        await tester.tap(find.text('Get random trivia'));
        await tester.pump();

        // assert
        verify(numberTriviaBlocMock.add(const GetTriviaForRandomNumber()));
      });
    });
  });
}
