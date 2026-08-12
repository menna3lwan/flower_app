import 'package:equatable/equatable.dart';

import '../../domain/entities/splash_destination.dart';

/// Every state the Splash screen can be in (MVI Model); only [SplashCubit] moves between them, the view just reacts.
sealed class SplashState extends Equatable {
  const SplashState();

  @override
  List<Object?> get props => [];
}

final class SplashInitial extends SplashState {
  const SplashInitial();
}

final class SplashInitializing extends SplashState {
  const SplashInitializing();
}

final class SplashReady extends SplashState {
  const SplashReady(this.destination);

  final SplashDestination destination;

  @override
  List<Object?> get props => [destination];
}

final class SplashFailed extends SplashState {
  const SplashFailed(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}
