import 'package:dartz/dartz.dart';
import 'package:mvvm_movies_app/core/errors/failures.dart';
import 'package:mvvm_movies_app/core/usecases/usecases.dart';
import 'package:mvvm_movies_app/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:mvvm_movies_app/features/number_trivia/domain/repositories/number_trivia_repo.dart';

class GetRandomNumberTrivia implements UseCase<NumberTrivia, NoParams> {
  final NumberTriviaRepo triviaRepo;

  GetRandomNumberTrivia(this.triviaRepo);

  @override
  Future<Either<Failure, NumberTrivia>> call(NoParams params) async {
    return await triviaRepo.getRandomNumberTrivia();
  }
}

