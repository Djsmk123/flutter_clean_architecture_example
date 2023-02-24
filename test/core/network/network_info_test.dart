// ignore: import_of_legacy_library_into_null_safe
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:mvvm_movies_app/core/network/network_info.dart';

import 'network_info_test.mocks.dart';
@GenerateMocks([DataConnectionChecker])
void main(){
  late MockDataConnectionChecker mockNetworkInfo;
  late NetworkInfoImpl networkInfoImpl;
  setUp((){
    mockNetworkInfo = MockDataConnectionChecker();
    networkInfoImpl = NetworkInfoImpl(mockNetworkInfo);
  });
  group('isConnected', (){
    test('should forward the call to DataConnectionChecker.hasConnection', () async{
      final tHasConnectionFuture = Future.value(true);
      when(mockNetworkInfo.hasConnection).thenAnswer((_) => tHasConnectionFuture);
      final result = networkInfoImpl.isConnected;
      verify(mockNetworkInfo.hasConnection);
      expect(result, tHasConnectionFuture);
    });
  });


}