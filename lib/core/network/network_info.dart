/// Connectivity check contract, consulted by repositories before hitting a remote data source. [ConnectivityNetworkInfo] (in `connectivity_network_info.dart`) is the production implementation.
abstract interface class NetworkInfo {
  Future<bool> get isConnected;
}
