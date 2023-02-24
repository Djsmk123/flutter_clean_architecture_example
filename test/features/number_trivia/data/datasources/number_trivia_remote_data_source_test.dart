import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:mvvm_movies_app/core/errors/exceptions.dart';
import 'package:mvvm_movies_app/features/number_trivia/data/datasources/number_trivia_remote_data_source.dart';
import 'package:mvvm_movies_app/features/number_trivia/data/models/number_trivia_model.dart';

import '../../../../Fixtures/fixture_reader.dart';
import 'number_trivia_remote_data_source_test.mocks.dart';
@GenerateMocks([http.Client])
void main(){
   late MockClient mockClient;
   late NumberTriviaRemoteDataSourceImpl numberTriviaRemoteDataSourceImpl;
    setUp((){
      mockClient = MockClient();
      numberTriviaRemoteDataSourceImpl = NumberTriviaRemoteDataSourceImpl(client: mockClient);
    });
    group('getConcreteNumberTrivia',()
   {
     const tNumber = 1;
     test(

         'should return NumberTrivia when the response code is 200 (success)', () async {
          // arrange
           when(
              mockClient.get(any, headers: anyNamed('headers'))
           ).thenAnswer((realInvocation) async=> http.Response(fixture('trivia'), 200));
           // act
            final result = await numberTriviaRemoteDataSourceImpl.getConcreteNumberTrivia(tNumber);
            // assert
            verify(mockClient.get(Uri.parse('http://numbersapi.com/$tNumber'), headers: {'Content-Type': 'application/json'}));
            expect(result, equals(NumberTriviaModel.fromJson(json.decode(fixture('trivia')))));
     });
     test('should throw a ServerException when the response code is 404 or other', () async {
       // arrange
       when(
           mockClient.get(any, headers: anyNamed('headers'))
       ).thenAnswer((realInvocation) async=> http.Response('Something went wrong', 404));
       // act
       final call = numberTriviaRemoteDataSourceImpl.getConcreteNumberTrivia;
       // assert
       expect(()=>call(tNumber), throwsA(const TypeMatcher<ServerException>()));
     });
   });
   group('getRandomNumberTrivia',()
   {
     test(

         'should return NumberTrivia when the response code is 200 (success)', () async {
       // arrange
       when(
           mockClient.get(any, headers: anyNamed('headers'))
       ).thenAnswer((realInvocation) async=> http.Response(fixture('trivia'), 200));
       // act
       final result = await numberTriviaRemoteDataSourceImpl.getRandomNumberTrivia();
       // assert
       verify(mockClient.get(Uri.parse('http://numbersapi.com/random'), headers: {'Content-Type': 'application/json'}));
       expect(result, equals(NumberTriviaModel.fromJson(json.decode(fixture('trivia')))));
     });
     test('should throw a ServerException when the response code is 404 or other', () async {
       // arrange
       when(
           mockClient.get(any, headers: anyNamed('headers'))
       ).thenAnswer((realInvocation) async=> http.Response('Something went wrong', 404));
       // act
       final call = numberTriviaRemoteDataSourceImpl.getRandomNumberTrivia;
       // assert
       expect(()=>call(), throwsA(const TypeMatcher<ServerException>()));
     });
   });

}