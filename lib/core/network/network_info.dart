/// Connectivity check contract; default impl always reports "connected" since nothing remote exists to gate yet.
abstract interface class NetworkInfo {
  Future<bool> get isConnected;
}

class AlwaysOnlineNetworkInfo implements NetworkInfo {
  const AlwaysOnlineNetworkInfo();

  @override
  Future<bool> get isConnected async => true;
}
