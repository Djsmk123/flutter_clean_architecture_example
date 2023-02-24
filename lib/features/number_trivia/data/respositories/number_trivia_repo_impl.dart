import 'package:dartz/dartz.dart';
import 'package:mvvm_movies_app/core/errors/failures.dart';
import 'package:mvvm_movies_app/core/network//network_info.dart';
import 'package:mvvm_movies_app/features/number_trivia/data/datasources/number_trivia_local_data_source.dart';
import 'package:mvvm_movies_app/features/number_trivia/data/datasources/number_trivia_remote_data_source.dart';
import 'package:mvvm_movies_app/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:mvvm_movies_app/features/number_trivia/domain/repositories/number_trivia_repo.dart';

import '../../../../core/errors/exceptions.dart';
import '../models/number_trivia_model.dart';
typedef _ConcreteOrRandomChooser = Future<NumberTrivia> Function();
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
     return await _getTrivia(() => remoteDataSource.getConcreteNumberTrivia(number));
  }

  @override
  Future<Either<Failure, NumberTrivia>> getRandomNumberTrivia() async {
    return await _getTrivia(() => remoteDataSource.getRandomNumberTrivia());
  }
  Future<Either<Failure,NumberTrivia>> _getTrivia(
      _ConcreteOrRandomChooser getConcreteOrRandom
      ) async{
    if(await networkInfo.isConnected) {
      try{
        final remoteTrivia = await getConcreteOrRandom();
        localDataSource.cacheNumberTrivia(
            NumberTriviaModel(number: remoteTrivia.number, text: remoteTrivia.text)
        );
        return Right(remoteTrivia);
      }on ServerException{
        return Left(ServerFailure());
      }
    }else{
      try{
        final localTrivia = await localDataSource.getLastNumber();
        return Right(localTrivia);
      }on CacheException{
        return Left(CacheFailure());
      }
    }
  }


}
