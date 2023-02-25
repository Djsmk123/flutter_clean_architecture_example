import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:mvvm_movies_app/core/errors/failures.dart';
import 'package:mvvm_movies_app/core/utli/input_converter.dart';
import 'package:mvvm_movies_app/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:mvvm_movies_app/features/number_trivia/domain/usecases/get_concrete_number_usecase.dart';
import 'package:mvvm_movies_app/features/number_trivia/domain/usecases/get_random_number_usecase.dart';
import 'package:mvvm_movies_app/features/number_trivia/presentation/bloc/bloc.dart';

import 'number_trivia_bloc_test.mocks.dart';

@GenerateMocks([GetConcreteNumberTrivia, GetRandomNumberTrivia, InputConverter])
void main() {
  late MockGetConcreteNumberTrivia getConcreteNumberTrivia;
  late MockGetRandomNumberTrivia getRandomNumberTrivia;
  late MockInputConverter inputConverter;
  late NumberTriviaBloc bloc;
  setUpAll(() {
    getConcreteNumberTrivia = MockGetConcreteNumberTrivia();
    getRandomNumberTrivia = MockGetRandomNumberTrivia();
    inputConverter = MockInputConverter();
    bloc = NumberTriviaBloc(
        getConcreteNumberTrivia: getConcreteNumberTrivia,
        getRandomNumberTrivia: getRandomNumberTrivia,
        inputConverter: inputConverter);
  });
  test('initialState should be Empty', () async {
    // assert
    expect(bloc.state, equals(Empty()));
  });
  group('GetTriviaForConcreteNumber', () {
    const tn = '1';
    const tNumberParsed = 1;
    const tNumberTrivia = NumberTrivia(text: 'test trivia', number: 1);
    void setUpMockInputConverterSuccess() =>
        when(inputConverter.stringToUnsignedInteger(any))
            .thenReturn(const Right(tNumberParsed));
    /*  test('should call the InputConverter to validate and convert the string to an unsigned integer', () async {
      // arrange
      setUpMockInputConverterSuccess();
      // act
      bloc.add((const GetTriviaForConcreteNumber(tn)));
      await untilCalled(inputConverter.stringToUnsignedInteger(any));
      // assert
      verify(inputConverter.stringToUnsignedInteger(tn));

    });*/
    test('should emit [Error] when the input is invalid', () async {
      // arrange
      when(inputConverter.stringToUnsignedInteger(tn))
          .thenReturn(Left(InvalidInputFailure()));
      // assert later
      final expected = [
        const Error(message: INVALID_INPUT_FAILURE_MESSAGE),
      ];
      expectLater(bloc.stream, emitsInOrder(expected));
      // act
      bloc.add(const GetTriviaForConcreteNumber(tn));
    });
    test('should get data from the concrete use case', () async {
      //arrange
      setUpMockInputConverterSuccess();
      when(getConcreteNumberTrivia(any))
          .thenAnswer((_) async => const Right(tNumberTrivia));
      // act
      bloc.add(const GetTriviaForConcreteNumber(tn));
      await untilCalled(getConcreteNumberTrivia(any));
      // assert
      verify(getConcreteNumberTrivia(const Params(number: tNumberParsed)));
    });
    test('should emit [Loading, Loaded] when data is gotten successfully',
        () async {
      // arrange
      setUpMockInputConverterSuccess();
      when(getConcreteNumberTrivia(any))
          .thenAnswer((_) async => const Right(tNumberTrivia));
      // assert later
      final expected = [
        Loading(),
        const Loaded(trivia: tNumberTrivia),
      ];
      expectLater(bloc.stream, emitsInOrder(expected));
      // act
      bloc.add(const GetTriviaForConcreteNumber(tn));
    });
    test('should emit [Loading, Error] when getting data fails', () async {
      // arrange
      setUpMockInputConverterSuccess();
      when(getConcreteNumberTrivia(any))
          .thenAnswer((_) async => Left(ServerFailure()));
      // assert later
      final expected = [
        Loading(),
        const Error(message: SERVER_FAILURE_MESSAGE),
      ];
      expectLater(bloc.stream, emitsInOrder(expected));
      // act
      bloc.add(const GetTriviaForConcreteNumber(tn));
    });
    test(
        'should emit [Loading, Error] with a proper message for the error when getting data fails',
        () async {
      // arrange
      setUpMockInputConverterSuccess();
      when(getConcreteNumberTrivia(any))
          .thenAnswer((_) async => Left(CacheFailure()));
      // assert later
      final expected = [
        Loading(),
        const Error(message: CACHE_FAILURE_MESSAGE),
      ];
      expectLater(bloc.stream, emitsInOrder(expected));
      // act
      bloc.add(const GetTriviaForConcreteNumber(tn));
    });
  });

  group('GetTriviaForRandomNumber', () {
    const tNumberTrivia = NumberTrivia(text: 'test trivia', number: 1);

    test('should get data from the concrete use case', () async {
      //arrange
      when(getRandomNumberTrivia(any))
          .thenAnswer((_) async => const Right(tNumberTrivia));
      // act
      bloc.add(GetTriviaForRandomNumber());
      await untilCalled(getRandomNumberTrivia(any));
      // assert
      verify(getRandomNumberTrivia(any));
    });
    test('should emit [Loading, Loaded] when data is gotten successfully',
        () async {
      // arrange
      when(getRandomNumberTrivia(any))
          .thenAnswer((_) async => const Right(tNumberTrivia));
      // assert later
      final expected = [
        Loading(),
        const Loaded(trivia: tNumberTrivia),
      ];
      expectLater(bloc.stream, emitsInOrder(expected));
      // act
      bloc.add(GetTriviaForRandomNumber());
    });
    test('should emit [Loading, Error] when getting data fails', () async {
      // arrange

      when(getRandomNumberTrivia(any))
          .thenAnswer((_) async => Left(ServerFailure()));
      // assert later
      final expected = [
        Loading(),
        const Error(message: SERVER_FAILURE_MESSAGE),
      ];
      expectLater(bloc.stream, emitsInOrder(expected));
      // act
      bloc.add(GetTriviaForRandomNumber());
    });
    test(
        'should emit [Loading, Error] with a proper message for the error when getting data fails',
        () async {
      // arrange
      when(getRandomNumberTrivia(any))
          .thenAnswer((_) async => Left(CacheFailure()));
      // assert later
      final expected = [
        Loading(),
        const Error(message: CACHE_FAILURE_MESSAGE),
      ];
      expectLater(bloc.stream, emitsInOrder(expected));
      // act
      bloc.add(GetTriviaForRandomNumber());
    });
  });
}
