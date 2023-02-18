import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:mvvm_movies_app/core/usecases/usecases.dart';
import 'package:mvvm_movies_app/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:mvvm_movies_app/features/number_trivia/domain/repositories/number_trivia_repo.dart';
import 'package:mvvm_movies_app/features/number_trivia/domain/usecases/get_random_number_usecase.dart';

import 'getconcrete_number_trivia_test.mocks.dart';

@GenerateMocks([NumberTriviaRepo])
void main() {
  late GetRandomNumberTrivia usecase;
  late MockNumberTriviaRepo mockNumberTriviaRepo;
  setUp(() => {
        mockNumberTriviaRepo = MockNumberTriviaRepo(),
        usecase = GetRandomNumberTrivia(mockNumberTriviaRepo)
      });
  const tNumberTrivia = NumberTrivia(number: 1, text: "test");
  test('trivia', () async {
    when(mockNumberTriviaRepo.getRandomNumberTrivia())
        .thenAnswer((realInvocation) async => const Right(tNumberTrivia));
    //act
    final result = await usecase(NoParams());
    expect(result, equals(const Right(tNumberTrivia)));
    verify(mockNumberTriviaRepo.getRandomNumberTrivia());
    verifyNoMoreInteractions(mockNumberTriviaRepo);
  });
}
