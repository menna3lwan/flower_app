import 'package:flutter_bloc/flutter_bloc.dart';

/// [Cubit] wrapper that guards against emitting after close; business logic stays in the domain layer.
abstract class BaseCubit<State> extends Cubit<State> {
  BaseCubit(super.initialState);

  void safeEmit(State state) {
    if (!isClosed) {
      emit(state);
    }
  }
}
