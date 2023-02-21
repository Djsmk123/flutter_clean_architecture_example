import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mvvm_movies_app/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:mvvm_movies_app/features/number_trivia/domain/entities/number_trivia.dart';

import '../../../../Fixtures/fixture_reader.dart';

void main() {
  const tNumberTriviaModel = NumberTriviaModel(text: "Test text", number: 1);
  test('should be subclass of Number Entity', () {
    expect(tNumberTriviaModel, isA<NumberTrivia>());
  });
  group('fromJson', () {
    test('should return a valid model when the json number is an integer',
        () async {
      //arrange
      final Map<String, dynamic> jsonMap = json.decode(fixture('trivia'));
      //act
      final result = NumberTriviaModel.fromJson(jsonMap);
      expect(result, tNumberTriviaModel);
      //assert
    });
    test('should return valid model when the json number is integer', () async {
      final Map<String, dynamic> jsonMap =
          json.decode(fixture('trivia_double'));
      final result = NumberTriviaModel.fromJson(jsonMap);
      expect(result, tNumberTriviaModel);
    });
  });
  group('toJson', () {
    test('should return  a json map containing the proper data', () async {
      final result = tNumberTriviaModel.toJson();
      final expectedMap = {'text': "Test text", 'number': 1};
      expect(result, expectedMap);
    });
  });
}
