import 'package:clean_architecture_tdd/core/useCases/use_case.dart';
import 'package:clean_architecture_tdd/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:clean_architecture_tdd/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:clean_architecture_tdd/features/number_trivia/domain/useCases/get_random_trivia.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '__mocks__/get_concrete_number_trivia_test.mocks.dart';

/// To mock the repository, we need to create a mock class that extends the
/// repository class. We can do this manually, and then we need to use the
/// @GenerateNiceMocks annotation to generate the mock class.

@GenerateNiceMocks([MockSpec<NumberTriviaRepository>()])
void main() {
  // late means that the variable will be initialized later
  // final means that the variable will be initialized immediately
  // const means that the variable will be initialized immediately and will not change
  late MockNumberTriviaRepository numberTriviaRepositoryMock;
  late GetRandomNumberTrivia useCase;

  // a function that will be called before each test
  setUp(() {
    numberTriviaRepositoryMock = MockNumberTriviaRepository();
    useCase = GetRandomNumberTrivia(numberTriviaRepositoryMock);
  });

  const tNumberTrivia = NumberTrivia(text: 'test', number: 1);

  group('GetConcreteRandomNumberTrivia tests', () {
    test('should get trivia for the number from the repository', () async {
      // arrange
      when(numberTriviaRepositoryMock.getRandomNumberTrivia())
          .thenAnswer((_) async => const Right(tNumberTrivia));

      // act
      final result = await useCase(NoParams());

      // assert
      expect(result, const Right(tNumberTrivia));
      verify(numberTriviaRepositoryMock.getRandomNumberTrivia());
      verifyNoMoreInteractions(numberTriviaRepositoryMock);
    });
  });
}
