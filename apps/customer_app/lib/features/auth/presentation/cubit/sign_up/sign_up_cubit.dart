import 'package:core/base/base_cubit.dart';
import 'package:shared/domain/entities/user_entity.dart';
import '../../../domain/repositories/auth_repository.dart';
import './sign_up_state.dart';

class SignUpCubit extends BaseCubit<SignUpState> {
  SignUpCubit(this._authRepository) : super(const SignUpInitial());

  final AuthRepository _authRepository;

  Future<void> signUp({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required String phoneNumber,
    required Gender gender,
  }) async {
    safeEmit(const SignUpSubmitting());
    final result = await _authRepository.signUp(
      firstName: firstName,
      lastName: lastName,
      email: email,
      password: password,
      phoneNumber: phoneNumber,
      gender: gender,
    );
    result.fold(
      (failure) => safeEmit(SignUpFailed(failure.message)),
      (user) => safeEmit(SignUpSuccess(user)),
    );
  }
}
