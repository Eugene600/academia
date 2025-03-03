import 'package:academia/core/user/repository/user_repository.dart';
import 'package:academia/database/database.dart';
import 'package:academia/exports/barrel.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';

part 'auth_event.dart';
part 'auth_state.dart';

final class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final UserRepository _userRepository = UserRepository();
  final _logger = Logger();

  AuthBloc() : super(AuthInitialState()) {
    on<AppLaunchDetected>((event, emit) async {
      emit(AuthLoadingState());
      final result = await _userRepository.fetchUserFromCache();
      return result.fold((error) {
        _logger.e(error, time: DateTime.now());
        return emit(AuthErrorState(error: error));
      }, (user) {
        if (user == null) {
          _logger.i("No user retrieved", time: DateTime.now());
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
        _logger.e(error, time: DateTime.now());
        return emit(AuthErrorState(error: error));
      }, (user) {
        _logger.d(user.toJson(), time: DateTime.now());
        return emit(AuthenticatedState(user: user));
      });
    });

    // Registration flow

    on<RegistrationEventRequested>((event, emit) async {
      if (event.password.trim().isEmpty || event.password.trim().length < 6) {
        return emit(AuthErrorState(error: "Please enter a valid password"));
      }
      if (event.admno.trim().isEmpty) {
        return emit(
          AuthErrorState(error: "Please enter a valid admission number"),
        );
      }

      emit(AuthLoadingState());
      final result = await _userRepository.fetchUserDetailsFromMagnet(
        UserCredentialData(
            admno: event.admno.trim(),
            username: '',
            email: '',
            password: event.password.trim()),
      );

      return result.fold((error) {
        _logger.e(error, time: DateTime.now());
        return emit(AuthErrorState(error: error));
      }, (user) {
        // add user password to the dict
        user['profile'] = user['profile']!.split(',').last;
        user.addAll({'password': event.password});
        _logger.d(user, time: DateTime.now());
        return emit(NewAuthUserDetailsFetched(userDetails: user));
      });
    });

    on<SignupEventRequested>((event, emit) async {
      emit(AuthLoadingState());
      final result = await _userRepository.completeRegistration(
        event.user,
        event.profile,
        event.creds,
      );

      return result.fold((error) {
        _logger.e(error, time: DateTime.now());
        return emit(AuthErrorState(error: error));
      }, (ok) {
        emit(AuthenticatedState(user: event.user));
      });
    });

    on<LogoutRequested>((event, emit) async {
      emit(AuthLoadingState());

      final result = await _userRepository.logout(event.user);

      result.fold((error) {
        _logger.e(error, error: error);
        emit(AuthErrorState(error: error));

        // To prevent errors since the user logout was unsuccessfull
        emit(AuthenticatedState(user: event.user));
      }, (message) {
        emit(UnauthenticatedState(message: message));
      });
    });
  }
}
