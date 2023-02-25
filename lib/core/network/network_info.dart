// ignore: import_of_legacy_library_into_null_safe
import 'package:internet_connection_checker/internet_connection_checker.dart';
abstract class NetworkInfo {
  Future<bool> get isConnected;
}
class NetworkInfoImpl extends NetworkInfo{
  final InternetConnectionChecker dataConnectionChecker;

  NetworkInfoImpl(this.dataConnectionChecker);
  @override
  Future<bool> get isConnected {
    return dataConnectionChecker.hasConnection;
  }


}