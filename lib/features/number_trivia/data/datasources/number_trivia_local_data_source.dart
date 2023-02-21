import 'package:mvvm_movies_app/features/number_trivia/data/models/number_trivia_model.dart';

abstract class NumberTriviaLocalDataSource {
  /// Gets the cached [NumberTriviaModel] which was gotten the last time
  Future<NumberTriviaModel> getLastNumber();

  /// Caches the [NumberTriviaModel] which was gotten the last time
  Future<void> cacheNumberTrivia(NumberTriviaModel triviaToCache);
}
