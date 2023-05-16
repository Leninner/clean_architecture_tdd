import 'package:clean_architecture_tdd/core/error/failures.dart';
import 'package:clean_architecture_tdd/core/useCases/use_case.dart';
import 'package:clean_architecture_tdd/core/util/input_converter.dart';
import 'package:clean_architecture_tdd/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:clean_architecture_tdd/features/number_trivia/domain/useCases/get_concrete_number_trivia.dart';
import 'package:clean_architecture_tdd/features/number_trivia/domain/useCases/get_random_trivia.dart';
import 'package:clean_architecture_tdd/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:bloc_test/bloc_test.dart';

import 'number_trivia_bloc_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<GetConcreteNumberTrivia>(),
  MockSpec<GetRandomNumberTrivia>(),
  MockSpec<InputConverter>()
])
void main() {
  late NumberTriviaBloc bloc;
  late MockGetConcreteNumberTrivia mockGetConcreteNumberTrivia;
  late MockGetRandomNumberTrivia mockGetRandomNumberTrivia;
  late MockInputConverter mockInputConverter;

  setUp(() {
    mockGetConcreteNumberTrivia = MockGetConcreteNumberTrivia();
    mockGetRandomNumberTrivia = MockGetRandomNumberTrivia();
    mockInputConverter = MockInputConverter();

    bloc = NumberTriviaBloc(
      mockGetConcreteNumberTrivia,
      mockGetRandomNumberTrivia,
      mockInputConverter,
    );
  });

  const tNumberParsed = 1;
  const String SERVER_FAILURE_MESSAGE = 'Server Failure';
  const String CACHE_FAILURE_MESSAGE = 'Cache Failure';
  const String INVALID_INPUT_FAILURE_MESSAGE =
      'Invalid Input - The number must be a positive integer or zero';

  void setUpMockInputConverterSuccess() =>
      when(mockInputConverter.stringToUnsignedInteger(any))
          .thenReturn(const Right(tNumberParsed));

  void setUpMockInputConverterFailure() =>
      when(mockInputConverter.stringToUnsignedInteger(any))
          .thenReturn(Left(InvalidInputFailure()));

  void setUpMockGetConcreteNumberTriviaSuccess() =>
      when(mockGetConcreteNumberTrivia(any)).thenAnswer((_) async =>
          const Right(NumberTrivia(text: 'test', number: tNumberParsed)));

  void setUpMockGetConcreteNumberTriviaServerFailure() =>
      when(mockGetConcreteNumberTrivia(any))
          .thenAnswer((_) async => Left(ServerFailure()));

  void setUpMockGetConcreteNumberTriviaCacheFailure() =>
      when(mockGetConcreteNumberTrivia(any))
          .thenAnswer((_) async => Left(CacheFailure()));

  group('NumberTriviaBloc tests', () {
    test('initialState should be Empty', () {
      expect(bloc.initialState, equals(Empty()));
    });

    group('When the GetNumberForConcreteTrivia event occurs', () {
      const tNumberString = '1';
      const tNumberTrivia = NumberTrivia(text: 'test', number: 1);

      blocTest(
        'should call the InputConverter to validate and convert the string to an unsigned integer',
        build: () => bloc,
        setUp: () {
          setUpMockInputConverterSuccess();
          setUpMockGetConcreteNumberTriviaSuccess();
        },
        act: (bloc) => bloc.add(GetTriviaForConcreteNumber(tNumberString)),
        verify: (_) {
          verify(mockInputConverter.stringToUnsignedInteger(tNumberString));
        },
      );

      blocTest(
        'should emit [Error] when the input is invalid',
        build: () => bloc,
        setUp: () {
          setUpMockInputConverterFailure();
        },
        act: (bloc) => bloc.add(GetTriviaForConcreteNumber(tNumberString)),
        expect: () => [const Error(message: INVALID_INPUT_FAILURE_MESSAGE)],
      );

      blocTest('should get data from the concrete use case',
          build: () => bloc,
          setUp: () {
            setUpMockInputConverterSuccess();
            setUpMockGetConcreteNumberTriviaSuccess();
          },
          act: (bloc) => bloc.add(GetTriviaForConcreteNumber(tNumberString)),
          verify: (_) {
            verify(mockGetConcreteNumberTrivia(
                const Params(number: tNumberParsed)));
          });

      blocTest(
        'should emit [Loading, Loaded] when data is gotten succesfully',
        build: () => bloc,
        setUp: () {
          setUpMockInputConverterSuccess();
          setUpMockGetConcreteNumberTriviaSuccess();
        },
        act: (bloc) => bloc.add(GetTriviaForConcreteNumber(tNumberString)),
        expect: () => [
          Loading(),
          const Loaded(trivia: tNumberTrivia),
        ],
      );

      blocTest(
        'should emit [Loading, Error] when getting data fails',
        build: () => bloc,
        setUp: () {
          setUpMockInputConverterSuccess();
          setUpMockGetConcreteNumberTriviaServerFailure();
        },
        act: (bloc) => bloc.add(GetTriviaForConcreteNumber(tNumberString)),
        expect: () => [
          Loading(),
          const Error(message: SERVER_FAILURE_MESSAGE),
        ],
      );

      blocTest(
        'should emit [Loading, Error] with a proper message for the error when getting data fails',
        build: () => bloc,
        setUp: () {
          setUpMockInputConverterSuccess();
          setUpMockGetConcreteNumberTriviaCacheFailure();
        },
        act: (bloc) => bloc.add(GetTriviaForConcreteNumber(tNumberString)),
        expect: () => [
          Loading(),
          const Error(message: CACHE_FAILURE_MESSAGE),
        ],
      );
    });

    group('When the GetNumberForRandomTrivia event occurs', () {
      const tNumberTrivia = NumberTrivia(text: 'test', number: 1);

      void setUpMockGetRandomNumberTriviaSuccess() =>
          when(mockGetRandomNumberTrivia(any)).thenAnswer((_) async =>
              const Right(NumberTrivia(text: 'test', number: tNumberParsed)));

      void setUpMockGetRandomNumberTriviaServerFailure() =>
          when(mockGetRandomNumberTrivia(any))
              .thenAnswer((_) async => Left(ServerFailure()));

      void setUpMockGetRandomNumberTriviaCacheFailure() =>
          when(mockGetRandomNumberTrivia(any))
              .thenAnswer((_) async => Left(CacheFailure()));

      blocTest('should get data from the random use case',
          build: () => bloc,
          setUp: () {
            setUpMockGetRandomNumberTriviaSuccess();
          },
          act: (bloc) => bloc.add(const GetTriviaForRandomNumber()),
          verify: (_) {
            verify(mockGetRandomNumberTrivia(NoParams()));
          });

      blocTest(
        'should emit [Loading, Loaded] when data is gotten succesfully',
        build: () => bloc,
        setUp: () {
          setUpMockGetRandomNumberTriviaSuccess();
        },
        act: (bloc) => bloc.add(const GetTriviaForRandomNumber()),
        expect: () => [
          Loading(),
          const Loaded(trivia: tNumberTrivia),
        ],
      );

      blocTest(
        'should emit [Loading, Error] when getting data fails',
        build: () => bloc,
        setUp: () {
          setUpMockGetRandomNumberTriviaServerFailure();
        },
        act: (bloc) => bloc.add(const GetTriviaForRandomNumber()),
        expect: () => [
          Loading(),
          const Error(message: SERVER_FAILURE_MESSAGE),
        ],
      );

      blocTest(
        'should emit [Loading, Error] with a proper message for the error when getting data fails',
        build: () => bloc,
        setUp: () {
          setUpMockGetRandomNumberTriviaCacheFailure();
        },
        act: (bloc) => bloc.add(const GetTriviaForRandomNumber()),
        expect: () => [
          Loading(),
          const Error(message: CACHE_FAILURE_MESSAGE),
        ],
      );
    });
  });
}
