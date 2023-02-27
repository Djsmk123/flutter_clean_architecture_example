import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mvvm_movies_app/core/utli/input_converter.dart';
import 'package:mvvm_movies_app/features/number_trivia/domain/usecases/get_concrete_number_usecase.dart';
import 'package:mvvm_movies_app/features/number_trivia/domain/usecases/get_random_number_usecase.dart';
import 'package:mvvm_movies_app/features/number_trivia/presentation/bloc/bloc.dart';

import '../../../../injection_container.dart';
import '../../domain/entities/number_trivia.dart';
import '../widgets/number_trivia_widgets.dart';

class NumberTriviaPage extends StatelessWidget {
  const NumberTriviaPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Number Trivia'),
        backgroundColor: Colors.green.shade800,
      ),
      body: buildBody(context),
    );
  }

  Widget buildBody(context) {
    return BlocProvider(

  create: (BuildContext context) {
    return NumberTriviaBloc(
      getConcreteNumberTrivia: sl(),
      inputConverter: sl(),
      getRandomNumberTrivia: sl(),
    );
  },
  child: Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          const SizedBox(
            height: 10,
          ),
          BlocBuilder<NumberTriviaBloc,NumberTriviaState>(builder: (context, state) {
            if(state is Empty){
              return const MessageDisplay(message: 'Start searching!');
            }
            else if(state is Loading){
              return const LoadingWidget();
            }
            else if(state is Loaded){
              return TriviaDisplay(numberTrivia: state.trivia);
            }
            else if(state is Error){
              return MessageDisplay(message: state.message);
            }
            return const MessageDisplay(message: 'Start searching!');
          }),
          const SizedBox(
            height: 20,
          ),
          TriviaControl()
        ],
      ),
    ),
);
  }
}






