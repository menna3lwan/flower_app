/// Connectivity check contract, consulted by repositories before hitting
/// a remote data source (`if (!await networkInfo.isConnected) return
/// Result.failure(NetworkFailure())`).
///
/// The default implementation always reports "connected" — there is no
/// remote call in the app yet for connectivity to gate. Swap in a real
/// implementation backed by `connectivity_plus` when [ApiClient] gets a
/// concrete implementation.
abstract interface class NetworkInfo {
  Future<bool> get isConnected;
}

class AlwaysOnlineNetworkInfo implements NetworkInfo {
  const AlwaysOnlineNetworkInfo();

  @override
  Future<bool> get isConnected async => true;
}
