import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:mvvm_movies_app/core/errors/exceptions.dart';
import 'package:mvvm_movies_app/features/number_trivia/data/datasources/number_trivia_local_data_source.dart';
import 'package:mvvm_movies_app/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../Fixtures/fixture_reader.dart';
import 'number_trivia_local_data_source_test.mocks.dart';
@GenerateMocks([SharedPreferences])
void main(){
  late MockSharedPreferences mockSharedPreferences;
  late NumberTriviaLocalDataSourceImpl numberTriviaLocalDataSourceImpl;
  setUp((){
    mockSharedPreferences = MockSharedPreferences();
    numberTriviaLocalDataSourceImpl = NumberTriviaLocalDataSourceImpl(mockSharedPreferences);
  });
  group('getLastNumberTrivia', (){
    final tNumberTrivia = NumberTriviaModel.fromJson(json.decode(fixture('trivia_cached')));
    test('should return NumberTrivia from SharedPreferences when there is one in the cache', () async{

      // arrange
      when(mockSharedPreferences.getString(any)).thenReturn(fixture('trivia_cached'));
      // act
      final result = await numberTriviaLocalDataSourceImpl.getLastNumber();
      // assert
      verify(mockSharedPreferences.getString(CACHED_NUMBER_TRIVIA));
      expect(result, equals(tNumberTrivia));
    });
    test('should throw a CacheException when there is not a cached value', () async{
      // arrange
      when(mockSharedPreferences.getString(any)).thenReturn(null);
      // act
      expect(()=>numberTriviaLocalDataSourceImpl.getLastNumber(), throwsA(const TypeMatcher<CacheException>()));
    });
  });

  group('catchNumberTrivia',(){
    const tNumberTriviaModel = NumberTriviaModel(number: 1, text: 'test trivia');
    test('should call SharedPreferences to cache the data', () async{
      // arrange

      when(mockSharedPreferences.setString(any, any)).thenAnswer((_) async => true);
      // act
      numberTriviaLocalDataSourceImpl.cacheNumberTrivia(
          tNumberTriviaModel
      );
      final expectedJsonString = json.encode(
         tNumberTriviaModel.toJson()
      );
      // assert
      verify(mockSharedPreferences.setString(CACHED_NUMBER_TRIVIA, expectedJsonString));
    });

  });

}