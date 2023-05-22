import 'package:clean_architecture_tdd/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TriviaControls extends StatelessWidget {
  String inputStr = '';

  TriviaControls({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        // text field
        TextField(
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            hintText: 'Input a number',
          ),
          onChanged: (value) {
            inputStr = value;
          },
          key: const Key('concrete_search_field'),
        ),
        const SizedBox(height: 10),
        Row(
          children: <Widget>[
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  dispatchConcrete(context);
                },
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.green),
                    textStyle: MaterialStateProperty.all(
                      const TextStyle(
                        color: Colors.white,
                      ),
                    )),
                child: const Text(
                  'Search',
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  dispatchRandom(context);
                },
                child: const Text(
                  'Get random trivia',
                ),
              ),
            ),
          ],
        )
      ],
    );
  }

  void dispatchConcrete(BuildContext context) {
    BlocProvider.of<NumberTriviaBloc>(context)
        .add(GetTriviaForConcreteNumber(inputStr));
  }

  void dispatchRandom(BuildContext context) {
    BlocProvider.of<NumberTriviaBloc>(context)
        .add(const GetTriviaForRandomNumber());
  }
}
