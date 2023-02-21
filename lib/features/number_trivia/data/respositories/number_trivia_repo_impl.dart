import 'package:dartz/dartz.dart';
import 'package:mvvm_movies_app/core/errors/failures.dart';
import 'package:mvvm_movies_app/core/plateform/network_info.dart';
import 'package:mvvm_movies_app/features/number_trivia/data/datasources/number_trivia_local_data_source.dart';
import 'package:mvvm_movies_app/features/number_trivia/data/datasources/number_trivia_remote_data_source.dart';
import 'package:mvvm_movies_app/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:mvvm_movies_app/features/number_trivia/domain/repositories/number_trivia_repo.dart';

class NumberTriviaRepoImpl implements NumberTriviaRepo {
  final NumberTriviaLocalDataSource localDataSource;
  final NumberTriviaRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;
  const NumberTriviaRepoImpl(
      {required this.localDataSource,
      required this.remoteDataSource,
      required this.networkInfo});

  @override
  Future<Either<Failure, NumberTrivia>> getConcreteNumberTrivia(
      int number) async {
    networkInfo.isConnected;
    return const Right(NumberTrivia(number: 1, text: "test trivia"));
  }

  @override
  Future<Either<Failure, NumberTrivia>> getRandomNumberTrivia() {
    // TODO: implement getRandomNumberTrivia
    throw UnimplementedError();
  }
}
