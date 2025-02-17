import 'package:academia/core/user/repository/user_repository.dart';
import 'package:academia/database/database.dart';
import 'package:academia/exports/barrel.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'auth_event.dart';
part 'auth_state.dart';

final class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final UserRepository _userRepository = UserRepository();

  AuthBloc() : super(AuthInitialState()) {
    on<AppLaunchDetected>((event, emit) async {
      emit(AuthLoadingState());
      final result = await _userRepository.fetchUserFromCache();
      return result.fold((error) {
        return emit(AuthErrorState(error: error));
      }, (user) {
        if (user == null) {
          return emit(AuthErrorState(error: "No such user"));
        }
        return emit(AuthenticatedState(user: user));
      });
    });

    on<AuthenticationRequested>((event, emit) async {
      if (event.password.trim().isEmpty || event.password.trim().length < 6) {
        return emit(AuthErrorState(error: "Please enter a valid password"));
      }
      if (event.admno.trim().isEmpty) {
        return emit(
          AuthErrorState(error: "Please enter a valid admission number"),
        );
      }

      emit(AuthLoadingState());
      final result = await _userRepository.authenticateRemotely(
        UserCredentialData(
            admno: event.admno.trim(),
            username: '',
            email: '',
            password: event.password.trim()),
      );

      return result.fold((error) {
        return emit(AuthErrorState(error: error));
      }, (user) {
        return emit(AuthenticatedState(user: user));
      });
    });
  }
}
