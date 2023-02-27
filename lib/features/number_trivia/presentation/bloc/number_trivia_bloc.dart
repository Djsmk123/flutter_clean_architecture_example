// ignore_for_file: constant_identifier_names

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecases.dart';
import '../../../../core/utli/input_converter.dart';
import '../../domain/entities/number_trivia.dart';
import '../../domain/usecases/get_concrete_number_usecase.dart';
import '../../domain/usecases/get_random_number_usecase.dart';

part 'number_trivia_event.dart';
part 'number_trivia_state.dart';

class NumberTriviaBloc extends Bloc<NumberTriviaEvent, NumberTriviaState> {
  final GetConcreteNumberTrivia getConcreteNumberTrivia;
  final GetRandomNumberTrivia getRandomNumberTrivia;
  final InputConverter inputConverter;
  NumberTriviaBloc(
      {required this.getConcreteNumberTrivia,
      required this.getRandomNumberTrivia,
      required this.inputConverter})
      : super(Empty()) {
    on<NumberTriviaEvent>((event, emit) async {
      if(event is GetTriviaForRandomNumber){
        emit(Loading());
        final failureOrTrivia = await getRandomNumberTrivia(NoParams());
        failureOrTrivia.fold((l) =>
            emit(Error(message: _mapFailureToMessage(l))), (r) => emit(Loaded(trivia: r)));
      }
      if(event is GetTriviaForConcreteNumber){
        final inputEither = inputConverter.stringToUnsignedInteger(event.numberString);
        emit(Loading());
        if(inputEither.isLeft()){
          emit(const Error(message: INVALID_INPUT_FAILURE_MESSAGE));
        }else {
          final failureOrTrivia = await getConcreteNumberTrivia(Params(number: inputEither.getOrElse(() => 0)));
          failureOrTrivia.fold((l) =>
              emit(Error(message: _mapFailureToMessage(l))), (r) => emit(Loaded(trivia: r)));
        }
      }
    });
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
}

const INVALID_INPUT_FAILURE_MESSAGE =
    'Invalid input - the number must be a positive integer or zero.';
const SERVER_FAILURE_MESSAGE = 'Server Failure';
const CACHE_FAILURE_MESSAGE = 'Cache Failure';
