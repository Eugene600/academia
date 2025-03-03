part of 'profile_cubit.dart';

@immutable
sealed class ProfileState {}

final class ProfileInitialState extends ProfileState {}

final class ProfileLoadingState extends ProfileState {}

final class ProfileErrorState extends ProfileState {
  final String error;
  ProfileErrorState({required this.error});
}

final class ProfileLoadedState extends ProfileState {
  final UserProfileData profile;
  ProfileLoadedState({required this.profile});
}
