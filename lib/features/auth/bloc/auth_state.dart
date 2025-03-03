part of 'auth_bloc.dart';

@immutable
sealed class AuthState {}

final class AuthInitialState extends AuthState {}

final class AuthLoadingState extends AuthState {}

final class AuthErrorState extends AuthState {
  final String error;
  AuthErrorState({required this.error});
}

final class AuthenticatedState extends AuthState {
  final UserData user;
  AuthenticatedState({required this.user});
}

final class NewAuthUserDetailsFetched extends AuthState {
  final Map<String, String> userDetails;
  NewAuthUserDetailsFetched({required this.userDetails});
}

final class UnauthenticatedState extends AuthState {
  final String? message;
  UnauthenticatedState({this.message});
}
