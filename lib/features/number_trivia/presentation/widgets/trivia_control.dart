import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/number_trivia_bloc.dart';

class TriviaControl extends StatefulWidget {
  const TriviaControl({Key? key}) : super(key: key);

  @override
  State<TriviaControl> createState() => _TriviaControlState();
}

class _TriviaControlState extends State<TriviaControl> {
  String inputString = '';
  final TextEditingController controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          onChanged: (value) {
            inputString = value;
          },
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            hintText: 'Input a number',
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
          children:  [
            Expanded(
              child: buildButton(
                dispatchConcrete,
                'Search',
                Colors.green,
              ),
              ),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              child: buildButton(
                    dispatchRandom,
                'Search Random',
                Colors.blueGrey.shade800
              ),
            ),
          ],
        ),
      ],
    );
  }

  MaterialButton buildButton(Function() onPressed, String text, Color color) {
    return MaterialButton(onPressed: onPressed,
              height: 50,
              color:color,
              child: Text(text,style: const TextStyle(
                color: Colors.white,
                fontSize: 20
              ),),
          );
  }
  void dispatchConcrete() {
    controller.clear();
    FocusScope.of(context).unfocus();
    BlocProvider.of<NumberTriviaBloc>(context).add(GetTriviaForConcreteNumber(inputString));
  }
  void dispatchRandom() {
    controller.clear();

    FocusScope.of(context).unfocus();

    BlocProvider.of<NumberTriviaBloc>(context).add(GetTriviaForRandomNumber());
  }
}

