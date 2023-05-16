part of 'number_trivia_bloc.dart';

abstract class NumberTriviaEvent extends Equatable {
  const NumberTriviaEvent([List props = const <dynamic>[]]) : super();

  @override
  List<Object> get props => [];
}

class GetTriviaForConcreteNumber extends NumberTriviaEvent {
  final String numberString;

  GetTriviaForConcreteNumber(this.numberString) : super([numberString]);

  @override
  List<Object> get props => [numberString];
}

class GetTrivaForRandomNumber extends NumberTriviaEvent {
  const GetTrivaForRandomNumber() : super();
}
