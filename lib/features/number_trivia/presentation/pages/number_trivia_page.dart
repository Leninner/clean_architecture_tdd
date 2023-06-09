import 'package:clean_architecture_tdd/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';
import 'package:clean_architecture_tdd/features/number_trivia/presentation/widgets/index.dart';
import 'package:clean_architecture_tdd/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NumberTriviaPage extends StatelessWidget {
  const NumberTriviaPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Number Trivia')),
        body: buildBody(context));
  }

  BlocProvider<NumberTriviaBloc> buildBody(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<NumberTriviaBloc>(),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(children: <Widget>[
            const SizedBox(height: 10),
            // top half
            BlocBuilder<NumberTriviaBloc, NumberTriviaState>(
              builder: (context, state) {
                if (state is Empty) {
                  return const MessageDisplay(
                    message: 'Start Searching!',
                  );
                }

                if (state is Loading) {
                  return const LoadingWidget();
                }

                if (state is Loaded) {
                  return TriviaDisplay(numberTrivia: state.trivia);
                }

                if (state is Error) {
                  return MessageDisplay(
                    message: state.message,
                  );
                }

                return const SizedBox.shrink();
              },
            ),
            const SizedBox(height: 20),
            TriviaControls()
          ]),
        ),
      ),
    );
  }
}
