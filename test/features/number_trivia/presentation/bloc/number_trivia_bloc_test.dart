import 'package:clean_architecture_tdd/core/error/failures.dart';
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
  // ignore: constant_identifier_names
  const String SERVER_FAILURE_MESSAGE = 'Server Failure';
// ignore: constant_identifier_names
  const String CACHE_FAILURE_MESSAGE = 'Cache Failure';
// ignore: constant_identifier_names
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

  void setUpMockGetConcreteNumberTriviaFailure() =>
      when(mockGetConcreteNumberTrivia(any))
          .thenAnswer((_) async => Left(ServerFailure()));

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

      blocTest(
          'should emits [Loading, Loaded] when data is gotten successfully',
          build: () => bloc,
          setUp: () {
            setUpMockInputConverterSuccess();
            setUpMockGetConcreteNumberTriviaSuccess();
          },
          act: (bloc) => bloc.add(GetTriviaForConcreteNumber(tNumberString)),
          expect: () => [Loading(), const Loaded(trivia: tNumberTrivia)]);
    });
  });
}
