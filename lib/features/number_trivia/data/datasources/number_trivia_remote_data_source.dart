import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:mvvm_movies_app/core/errors/exceptions.dart';
import 'package:mvvm_movies_app/features/number_trivia/data/models/number_trivia_model.dart';
abstract class NumberTriviaRemoteDataSource {
  Future<NumberTriviaModel> getConcreteNumberTrivia(int number);
  Future<NumberTriviaModel> getRandomNumberTrivia();
}

class NumberTriviaRemoteDataSourceImpl extends NumberTriviaRemoteDataSource{
  final http.Client client;
  NumberTriviaRemoteDataSourceImpl({required this.client});
  @override
  Future<NumberTriviaModel> getConcreteNumberTrivia(int number) async {
  return await _getTriviaFromUrl(Uri.parse('http://numbersapi.com/$number'));
  }

  @override
  Future<NumberTriviaModel> getRandomNumberTrivia() async{
    return await _getTriviaFromUrl(Uri.parse('http://numbersapi.com/random'));
  }

  Future<NumberTriviaModel> _getTriviaFromUrl(Uri url) async {
    final response = await client.get(
        url,
        headers: {
          'Content-Type': 'application/json',
        }
    );
    if(response.statusCode == 200) {
      return NumberTriviaModel.fromJson(json.decode(response.body));
    } else {
      throw ServerException();
    }
  }

}
