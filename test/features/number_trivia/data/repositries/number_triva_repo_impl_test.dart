import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:mvvm_movies_app/core/plateform/network_info.dart';
import 'package:mvvm_movies_app/features/number_trivia/data/datasources/number_trivia_local_data_source.dart';
import 'package:mvvm_movies_app/features/number_trivia/data/datasources/number_trivia_remote_data_source.dart';
import 'package:mvvm_movies_app/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:mvvm_movies_app/features/number_trivia/data/respositories/number_trivia_repo_impl.dart';

import 'number_triva_repo_impl_test.mocks.dart';

@GenerateMocks([NumberTriviaRemoteDataSource])
@GenerateMocks([NumberTriviaLocalDataSource])
@GenerateMocks([NetworkInfo])
void main() {
  late NumberTriviaRepoImpl numberTriviaRepoImpl;
  late MockNumberTriviaRemoteDataSource mockNumberTriviaRemoteDataSource;
  late MockNumberTriviaLocalDataSource mockNumberTriviaLocalDataSource;
  late MockNetworkInfo mockNetworkInfo;

  setUpAll(() {
    mockNumberTriviaRemoteDataSource = MockNumberTriviaRemoteDataSource();
    mockNumberTriviaLocalDataSource = MockNumberTriviaLocalDataSource();
    mockNetworkInfo = MockNetworkInfo();
    numberTriviaRepoImpl = NumberTriviaRepoImpl(
        localDataSource: mockNumberTriviaLocalDataSource,
        remoteDataSource: mockNumberTriviaRemoteDataSource,
        networkInfo: mockNetworkInfo);
  });

  group('getConcreteNumberTrivia', () {
    const tNumber = 1;
    const tNumberTriviaModel =
        NumberTriviaModel(number: 1, text: "test trivia");
    const tNumberTrivia = tNumberTriviaModel;

    test('should check if the device is online', () async {
      //arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async {
        return true;
      });
      //act
      numberTriviaRepoImpl.getConcreteNumberTrivia(tNumber);

      //assert
      verify(mockNetworkInfo.isConnected);
    });
    group('device is online', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((realInvocation) async {
          return true;
        });
        test('should remote data when call to remote data source is success',
            () async {
          //arrange
          when(mockNumberTriviaRemoteDataSource
                  .getConcreteNumberTrivia(tNumber))
              .thenAnswer((realInvocation) async {
            return tNumberTriviaModel;
          });

          final result =
              await numberTriviaRepoImpl.getConcreteNumberTrivia(tNumber);
          //assert
          verify(mockNumberTriviaRemoteDataSource
              .getConcreteNumberTrivia(tNumber));

          expect(result, equals(const Right(tNumberTrivia)));
        });
      });
    });
    /* group('device is offline', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((realInvocation) async {
          return false;
        });
      });
    });*/
  });
}
