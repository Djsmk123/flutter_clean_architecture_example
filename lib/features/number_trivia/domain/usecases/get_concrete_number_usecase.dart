import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:mvvm_movies_app/core/errors/failures.dart';
import 'package:mvvm_movies_app/core/usecases/usecases.dart';
import 'package:mvvm_movies_app/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:mvvm_movies_app/features/number_trivia/domain/repositories/number_trivia_repo.dart';

class GetConcreteNumberTrivia implements UseCase<NumberTrivia, Params> {
  final NumberTriviaRepo repo;
  GetConcreteNumberTrivia(this.repo);

  @override
  Future<Either<Failure, NumberTrivia>> call(Params params) async {
    return await repo.getConcreteNumberTrivia(params.number);
  }
}

class Params extends Equatable {
  final int number;
  const Params({required this.number});
  @override
  List<Object?> get props => [number];
}
