import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:mvvm_movies_app/core/errors/exceptions.dart';
import 'package:mvvm_movies_app/core/errors/failures.dart';
import 'package:mvvm_movies_app/core/network//network_info.dart';
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
  const tNumber = 1;
  const tNumberTriviaModel =
  NumberTriviaModel(number: 1, text: "test trivia");
  const tNumberTrivia = tNumberTriviaModel;
  setUpAll(() {
    mockNumberTriviaRemoteDataSource = MockNumberTriviaRemoteDataSource();
    mockNumberTriviaLocalDataSource = MockNumberTriviaLocalDataSource();
    mockNetworkInfo = MockNetworkInfo();
    numberTriviaRepoImpl = NumberTriviaRepoImpl(
        localDataSource: mockNumberTriviaLocalDataSource,
        remoteDataSource: mockNumberTriviaRemoteDataSource,
        networkInfo: mockNetworkInfo);

  });
  void runTestsOnline(Function body) {
    group('device is online', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((realInvocation) async {
          return true;
        });
      });
      body();
    });
  }
  void runTestsOffline(Function body) {
    group('device is offline', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((realInvocation) async {
          return false;
        });
      });
      body();
    });
  }
  group('getConcreteNumberTrivia', () {
    setUpAll(() =>{
    when(mockNumberTriviaRemoteDataSource.getConcreteNumberTrivia(any)).thenAnswer((realInvocation) async=>tNumberTriviaModel)
    });
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
    runTestsOnline(() {
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

        test('should cache data when call to remote data source is success',
                () async {
              //arrange
              when(mockNumberTriviaRemoteDataSource
                  .getConcreteNumberTrivia(tNumber))
                  .thenAnswer((realInvocation) async {
                return tNumberTriviaModel;
              });


              await numberTriviaRepoImpl.getConcreteNumberTrivia(tNumber);
              //assert
              verify(mockNumberTriviaRemoteDataSource
                  .getConcreteNumberTrivia(tNumber));

              verify(mockNumberTriviaLocalDataSource.cacheNumberTrivia(
                  tNumberTriviaModel));
            });
        test(
            'should return ServerFailure when call to remote data source is unsuccessful',
                () async {
              //arrange
              when(mockNumberTriviaRemoteDataSource.getConcreteNumberTrivia(
                  tNumber)).thenThrow(ServerException());
              //act
              final result = await numberTriviaRepoImpl.getConcreteNumberTrivia(
                  tNumber);
              //assert
              verify(mockNumberTriviaRemoteDataSource.getConcreteNumberTrivia(
                  tNumber));
              verifyZeroInteractions(mockNumberTriviaLocalDataSource);
              expect(result, equals(Left(ServerFailure())));
            });
      });
    });
    runTestsOffline(() {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((realInvocation) async {
          return false;
        });
      });
      test('should return last locally cached data when the cached data is present',
              () async {
            //arrange
            when(mockNumberTriviaLocalDataSource.getLastNumber())
                .thenAnswer((realInvocation) async {
              return tNumberTriviaModel;
            });
            //act
            final result =
            await numberTriviaRepoImpl.getConcreteNumberTrivia(tNumber);
            //assert
            //verifyZeroInteractions(mockNumberTriviaRemoteDataSource);
            verify(mockNumberTriviaLocalDataSource.getLastNumber());
            expect(result, equals(const Right(tNumberTrivia)));
          });
      test('should return CacheFailure when there is no cached data present',
              () async {
            //arrange
            when(mockNumberTriviaLocalDataSource.getLastNumber())
                .thenThrow(CacheException());
            //act
            final result =
            await numberTriviaRepoImpl.getConcreteNumberTrivia(tNumber);
            //assert
            //verifyZeroInteractions(mockNumberTriviaRemoteDataSource);
            verify(mockNumberTriviaLocalDataSource.getLastNumber());
            expect(result, equals(Left(CacheFailure())));
          });
    });
  });
  group('getRandomNumberTrivia', () {
    const tNumberTriviaModel = NumberTriviaModel(number: 123, text: "test trivia");
    const tNumberTrivia = tNumberTriviaModel;
    setUpAll(() {
      when(mockNumberTriviaRemoteDataSource.getRandomNumberTrivia())
          .thenAnswer((realInvocation) async => tNumberTriviaModel);
    });

    test('should check if the device is online', () async {
      //arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async {
        return true;
      });
      //act
      numberTriviaRepoImpl.getRandomNumberTrivia();

      //assert
      verify(mockNetworkInfo.isConnected);
    });


    runTestsOnline(() {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((realInvocation) async {
          return true;
        });
        test('should remote data when call to remote data source is success',
                () async {
              //arrange
              when(mockNumberTriviaRemoteDataSource
                  .getRandomNumberTrivia())
                  .thenAnswer((realInvocation) async {
                return tNumberTriviaModel;
              });

              final result =
              await numberTriviaRepoImpl.getRandomNumberTrivia();
              //assert
              verify(mockNumberTriviaRemoteDataSource
                  .getRandomNumberTrivia());

              expect(result, equals(const Right(tNumberTrivia)));
            });

        test('should cache data when call to remote data source is success',
                () async {
              //arrange
              when(mockNumberTriviaRemoteDataSource
                  .getRandomNumberTrivia())
                  .thenAnswer((realInvocation) async {
                return tNumberTriviaModel;
              });


              await numberTriviaRepoImpl.getRandomNumberTrivia();
              //assert
              verify(mockNumberTriviaRemoteDataSource
                  .getRandomNumberTrivia());

              verify(mockNumberTriviaLocalDataSource.cacheNumberTrivia(
                  tNumberTriviaModel));

            });
        test(
            'should return ServerFailure when call to remote data source is unsuccessful',
                () async {
              //arrange
              when(mockNumberTriviaRemoteDataSource.getRandomNumberTrivia(
                  )).thenThrow(ServerException());
              //act
              final result = await numberTriviaRepoImpl.getRandomNumberTrivia(
                  );
              //assert
              verify(mockNumberTriviaRemoteDataSource.getRandomNumberTrivia(
                  ));
              verifyZeroInteractions(mockNumberTriviaLocalDataSource);
              expect(result, equals(Left(ServerFailure())));
            });
      });
    });
    runTestsOffline(() {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((realInvocation) async {
          return false;
        });
      });
      test('should return last locally cached data when the cached data is present',
              () async {
            //arrange
            when(mockNumberTriviaLocalDataSource.getLastNumber())
                .thenAnswer((realInvocation) async {
              return tNumberTriviaModel;
            });
            //act
            final result =
            await numberTriviaRepoImpl.getRandomNumberTrivia();
            //assert
            //verifyZeroInteractions(mockNumberTriviaRemoteDataSource);
            verify(mockNumberTriviaLocalDataSource.getLastNumber());
            expect(result, equals(const Right(tNumberTrivia)));
          });
      test('should return CacheFailure when there is no cached data present',
              () async {
            //arrange
            when(mockNumberTriviaLocalDataSource.getLastNumber())
                .thenThrow(CacheException());
            //act
            final result =
            await numberTriviaRepoImpl.getRandomNumberTrivia();
            //assert
            //verifyZeroInteractions(mockNumberTriviaRemoteDataSource);
            verify(mockNumberTriviaLocalDataSource.getLastNumber());
            expect(result, equals(Left(CacheFailure())));
          });
    });
  });
}
