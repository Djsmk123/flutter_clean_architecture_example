import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:mvvm_movies_app/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:mvvm_movies_app/features/number_trivia/domain/repositories/number_trivia_repo.dart';
import 'package:mvvm_movies_app/features/number_trivia/domain/usecases/get_concrete_number_usecase.dart';

import 'getconcrete_number_trivia_test.mocks.dart';

@GenerateMocks([NumberTriviaRepo])
void main() {
  late GetConcreteNumberTrivia usecase;
  late MockNumberTriviaRepo mockNumberTriviaRepo;
  setUp(() => {
        mockNumberTriviaRepo = MockNumberTriviaRepo(),
        usecase = GetConcreteNumberTrivia(mockNumberTriviaRepo)
      });
  const tNumber = 1;
  const tNumberTrivia = NumberTrivia(number: 1, text: "test");
  test('should get number for the number from trivia', () async {
    when(mockNumberTriviaRepo.getConcreteNumberTrivia(tNumber))
        .thenAnswer((realInvocation) async => const Right(tNumberTrivia));
    //act
    final result = await usecase(const Params(number: tNumber));
    expect(result, equals(const Right(tNumberTrivia)));
    verify(mockNumberTriviaRepo.getConcreteNumberTrivia(tNumber));
    verifyNoMoreInteractions(mockNumberTriviaRepo);
  });
}
