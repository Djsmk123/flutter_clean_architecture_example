import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mvvm_movies_app/features/number_trivia/presentation/bloc/bloc.dart';

import '../../../../injection_container.dart';
import '../../domain/entities/number_trivia.dart';

class NumberTriviaPage extends StatelessWidget {
  const NumberTriviaPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Number Trivia'),
        backgroundColor: Colors.green.shade800,
      ),
      body: buildBody(),
    );
  }

  Widget buildBody() {
    return BlocProvider<NumberTriviaBloc>(
      create: (context) => sl<NumberTriviaBloc>(),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            BlocBuilder(builder: (context, state) {
              if (state is Empty) {
                return const MessageDisplay(message: 'Start searching!');
              } else if (state is Loading) {
                return const LoadingWidget();
              } else if (state is Loaded) {
                return TriviaDisplay(numberTrivia: state.trivia);
              } else if (state is Error) {
                return MessageDisplay(message: state.message);
              }
              return const MessageDisplay(message: 'Start searching!');
            }),
            const SizedBox(
              height: 20,
            ),
            Column(
              children: [
                const Placeholder(
                  fallbackHeight: 40,
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: const [
                    Expanded(
                      child: Placeholder(
                        fallbackHeight: 30,
                        fallbackWidth: 200,
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: Placeholder(
                        fallbackHeight: 30,
                        fallbackWidth: 200,
                      ),
                    ),
                  ],
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class MessageDisplay extends StatelessWidget {
  final String message;

  const MessageDisplay({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: MediaQuery.of(context).size.height / 3,
        child: Center(
          child: SingleChildScrollView(
            child: Text(
              message,
              style: const TextStyle(fontSize: 25),
              textAlign: TextAlign.center,
            ),
          ),
        ));
  }
}

class TriviaDisplay extends StatelessWidget {
  final NumberTrivia numberTrivia;

  const TriviaDisplay({Key? key, required this.numberTrivia}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          numberTrivia.number.toString(),
          style: const TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
        ),
        const SizedBox(
          height: 10,
        ),
        Center(
          child: SingleChildScrollView(
            child: Text(
              numberTrivia.text,
              style: const TextStyle(fontSize: 25),
              textAlign: TextAlign.center,
            ),
          ),
        )
      ],
    );
  }
}

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}
