
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:mvvm_movies_app/features/number_trivia/data/respositories/number_trivia_repo_impl.dart';
import 'package:mvvm_movies_app/features/number_trivia/domain/repositories/number_trivia_repo.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/network/network_info.dart';

import 'core/utli/input_converter.dart';
import 'features/number_trivia/data/datasources/number_trivia_local_data_source.dart';
import 'features/number_trivia/data/datasources/number_trivia_remote_data_source.dart';

import 'features/number_trivia/domain/usecases/get_concrete_number_usecase.dart';
import 'features/number_trivia/domain/usecases/get_random_number_usecase.dart';
import 'features/number_trivia/presentation/bloc/number_trivia_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  //! Features - Number Trivia
  // Bloc
  sl.registerFactory(
        () => NumberTriviaBloc(
      getConcreteNumberTrivia: sl(),
      inputConverter: sl(),
      getRandomNumberTrivia: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => GetConcreteNumberTrivia(sl()));
  sl.registerLazySingleton(() => GetRandomNumberTrivia(sl()));

  // Repository
  sl.registerLazySingleton<NumberTriviaRepo>(
        () => NumberTriviaRepoImpl(
      localDataSource: sl(),
      networkInfo: sl(),
      remoteDataSource: sl(),
    ),
  );

  // Data sources
  sl.registerLazySingleton<NumberTriviaRemoteDataSource>(
        () => NumberTriviaRemoteDataSourceImpl(client: sl()),
  );

  sl.registerLazySingleton<NumberTriviaLocalDataSource>(
        () => NumberTriviaLocalDataSourceImpl(sl()),
  );
  //! External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => http.Client());
  sl.registerLazySingleton(() => InternetConnectionChecker());
  //! Core
  sl.registerLazySingleton(() => InputConverter());
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));


}
