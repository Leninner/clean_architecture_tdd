import 'package:clean_architecture_tdd/core/util/input_converter.dart';
import 'package:clean_architecture_tdd/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:clean_architecture_tdd/features/number_trivia/domain/useCases/get_concrete_number_trivia.dart';
import 'package:clean_architecture_tdd/features/number_trivia/domain/useCases/get_random_trivia.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'number_trivia_event.dart';
part 'number_trivia_state.dart';

// ignore: constant_identifier_names
const String SERVER_FAILURE_MESSAGE = 'Server Failure';
// ignore: constant_identifier_names
const String CACHE_FAILURE_MESSAGE = 'Cache Failure';
// ignore: constant_identifier_names
const String INVALID_INPUT_FAILURE_MESSAGE =
    'Invalid Input - The number must be a positive integer or zero';

enum FailureMessages {
  // ignore: constant_identifier_names
  SERVER_FAILURE_MESSAGE,
  // ignore: constant_identifier_names
  CACHE_FAILURE_MESSAGE,
  // ignore: constant_identifier_names
  INVALID_INPUT_FAILURE_MESSAGE
}

class NumberTriviaBloc extends Bloc<NumberTriviaEvent, NumberTriviaState> {
  final GetConcreteNumberTrivia getConcreteNumberTrivia;
  final GetRandomNumberTrivia getRandomNumberTrivia;
  final InputConverter inputConverter;

  NumberTriviaBloc(
    this.getConcreteNumberTrivia,
    this.getRandomNumberTrivia,
    this.inputConverter,
  ) : super(Empty()) {
    on<GetTriviaForConcreteNumber>(_getTriviaForConcreteNumberHandler);
  }

  _getTriviaForConcreteNumberHandler(event, emit) {
    final inputEither =
        inputConverter.stringToUnsignedInteger(event.numberString);

    inputEither.fold(
      (failure) => emit(const Error(message: INVALID_INPUT_FAILURE_MESSAGE)),
      (integer) => emit(Loading()),
    );

    // inputEither.fold(
    //   (failure) => emit(const Error(message: SERVER_FAILURE_MESSAGE)),
    //   (integer) async {
    //     final failureOrTrivia =
    //         await getConcreteNumberTrivia(Params(number: integer));

    //     failureOrTrivia.fold(
    //       (failure) => emit(const Error(message: SERVER_FAILURE_MESSAGE)),
    //       (trivia) => emit(Loaded(trivia: trivia)),
    //     );
    //   },
    // );
  }

  NumberTriviaState get initialState => Empty();
}
