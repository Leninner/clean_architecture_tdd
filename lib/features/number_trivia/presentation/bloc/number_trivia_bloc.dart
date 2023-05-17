import 'package:clean_architecture_tdd/core/error/failures.dart';
import 'package:clean_architecture_tdd/core/useCases/use_case.dart';
import 'package:clean_architecture_tdd/core/util/input_converter.dart';
import 'package:clean_architecture_tdd/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:clean_architecture_tdd/features/number_trivia/domain/useCases/get_concrete_number_trivia.dart';
import 'package:clean_architecture_tdd/features/number_trivia/domain/useCases/get_random_trivia.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'number_trivia_event.dart';
part 'number_trivia_state.dart';

const String SERVER_FAILURE_MESSAGE = 'Server Failure';
const String CACHE_FAILURE_MESSAGE = 'Cache Failure';
const String INVALID_INPUT_FAILURE_MESSAGE =
    'Invalid Input - The number must be a positive integer or zero';

class NumberTriviaBloc extends Bloc<NumberTriviaEvent, NumberTriviaState> {
  final GetConcreteNumberTrivia getConcreteNumberTrivia;
  final GetRandomNumberTrivia getRandomNumberTrivia;
  final InputConverter inputConverter;

  NumberTriviaBloc({
    concrete,
    random,
    converter,
  })  : getConcreteNumberTrivia = concrete,
        getRandomNumberTrivia = random,
        inputConverter = converter,
        super(Empty()) {
    on<GetTriviaForConcreteNumber>(_getTriviaForConcreteNumberHandler);
    on<GetTriviaForRandomNumber>(_getTriviaForRandomNumberHandler);
  }

  _getTriviaForConcreteNumberHandler(event, emit) async {
    final inputEither =
        inputConverter.stringToUnsignedInteger(event.numberString);

    await inputEither.fold(
      (failure) => emit(const Error(message: INVALID_INPUT_FAILURE_MESSAGE)),
      (integer) async {
        emit(Loading());

        final futureOrTrivia =
            await getConcreteNumberTrivia(Params(number: integer));

        futureOrTrivia.fold(
          (failure) {
            emit(
              Error(message: _mapFailureToMessage(failure)),
            );
          },
          (trivia) {
            emit(
              Loaded(trivia: trivia),
            );
          },
        );
      },
    );
  }

  _getTriviaForRandomNumberHandler(event, emit) async {
    emit(Loading());

    final futureOrTrivia = await getRandomNumberTrivia(NoParams());

    futureOrTrivia.fold((failure) {
      emit(Error(message: _mapFailureToMessage(failure)));
    }, (trivia) => emit(Loaded(trivia: trivia)));
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return SERVER_FAILURE_MESSAGE;

      case CacheFailure:
        return CACHE_FAILURE_MESSAGE;

      default:
        return 'Unexpected error';
    }
  }

  NumberTriviaState get initialState => Empty();
}
