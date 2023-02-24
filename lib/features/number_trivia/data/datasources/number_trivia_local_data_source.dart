import 'dart:convert';

import 'package:mvvm_movies_app/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:mvvm_movies_app/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/errors/exceptions.dart';
// ignore: non_constant_identifier_names
String CACHED_NUMBER_TRIVIA = 'CACHED_NUMBER_TRIVIA';
abstract class NumberTriviaLocalDataSource {
  /// Gets the cached [NumberTrivia] which was gotten the last time
  Future<NumberTriviaModel> getLastNumber();

  /// Caches the [NumberTrivia] which was gotten the last time
  Future<void> cacheNumberTrivia(NumberTriviaModel triviaToCache);
}

class NumberTriviaLocalDataSourceImpl extends NumberTriviaLocalDataSource{
  final SharedPreferences sharedPreferences;
  NumberTriviaLocalDataSourceImpl(this.sharedPreferences);
  @override
  Future<void> cacheNumberTrivia(NumberTriviaModel triviaToCache) {
    final jsonString = json.encode(
        triviaToCache.toJson()
    );
    return sharedPreferences.setString(CACHED_NUMBER_TRIVIA, jsonString);
  }

  @override
  Future<NumberTriviaModel> getLastNumber() {
    final jsonString = sharedPreferences.getString(CACHED_NUMBER_TRIVIA);
    if(jsonString != null) {
      final jsonString = sharedPreferences.getString(CACHED_NUMBER_TRIVIA);
      final jsonMap = json.decode(jsonString!);
      return Future.value(NumberTriviaModel.fromJson(jsonMap));
    } else {
      throw CacheException();
    }

  }

}