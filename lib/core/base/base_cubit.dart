import 'package:flutter_bloc/flutter_bloc.dart';

/// Thin wrapper around [Cubit] that adds a single safety rail: never emit
/// after the cubit has been closed (a common source of
/// "Cannot emit new states after calling close" crashes when an async
/// use case resolves after its screen has been popped).
///
/// Every feature Cubit extends this instead of [Cubit] directly. Business
/// logic still lives in the domain layer (use cases/repositories) — this
/// class is purely presentation-layer plumbing, in line with the rule
/// that Cubits stay lightweight orchestrators.
abstract class BaseCubit<State> extends Cubit<State> {
  BaseCubit(super.initialState);

  void safeEmit(State state) {
    if (!isClosed) {
      emit(state);
    }
  }
}
