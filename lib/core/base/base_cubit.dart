import 'package:flutter_bloc/flutter_bloc.dart';

/// Thin wrapper around [Cubit] that guards against emitting after the cubit has closed.
abstract class BaseCubit<State> extends Cubit<State> {
  BaseCubit(super.initialState);

  void safeEmit(State state) {
    if (!isClosed) {
      emit(state);
    }
  }
}
