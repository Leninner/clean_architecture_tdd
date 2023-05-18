import 'package:clean_architecture_tdd/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:clean_architecture_tdd/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:clean_architecture_tdd/features/number_trivia/domain/useCases/get_concrete_number_trivia.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'get_random_number_trivia_test.mocks.dart';

/// To mock the repository, we need to create a decorator called
/// @GenerateNiceMocks annotation to generate the mock class.
/// After that, we need to create the actual files by running
/// flutter pub run build_runner build --delete-conflicting-outputs

@GenerateNiceMocks([MockSpec<NumberTriviaRepository>()])
void main() {
  // late means that the variable will be initialized later
  // final means that the variable will be initialized immediately
  // const means that the variable will be initialized immediately and will not change
  late MockNumberTriviaRepository numberTriviaRepositoryMock;
  late GetConcreteNumberTrivia useCase;

  // a function that will be called before each test
  setUp(() {
    numberTriviaRepositoryMock = MockNumberTriviaRepository();
    useCase = GetConcreteNumberTrivia(numberTriviaRepositoryMock);
  });

  const tNumber = 1;
  const tNumberTrivia = NumberTrivia(text: 'test', number: tNumber);

  group('GetConcreteNumberTrivia tests', () {
    test('should get trivia for the number from the repository', () async {
      // arrange
      when(numberTriviaRepositoryMock.getConcreteNumberTrivia(tNumber))
          .thenAnswer((_) async => const Right(tNumberTrivia));

      // act
      final result = await useCase(const Params(number: tNumber));

      // assert
      expect(result, const Right(tNumberTrivia));
      verify(numberTriviaRepositoryMock.getConcreteNumberTrivia(tNumber));
      verifyNoMoreInteractions(numberTriviaRepositoryMock);
    });

    test('should be true', () => expect(true, true));
  });
}
