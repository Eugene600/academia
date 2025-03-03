import 'package:academia/core/user/repository/user_repository.dart';
import 'package:academia/database/database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final Logger _logger = Logger();
  final UserRepository _userRepository = UserRepository();
  ProfileCubit() : super(ProfileInitialState());

  Future<void> fetchCachedUserProfile(UserData user) async {
    emit(ProfileLoadingState());
    final result = await _userRepository.fetchUserProfileFromCache(user);

    return result.fold((error) {
      _logger.e("Error while fetching user profile from cache $error",
          error: error);
      return emit(ProfileErrorState(error: error));
    }, (profile) {
      _logger.i("User profile fetched successfully");
      return emit(ProfileLoadedState(profile: profile));
    });
  }

  Future<void> updateUserProfile(UserProfileData profile) async {
    emit(ProfileLoadingState());
    final result = await _userRepository.updateUserProfile(profile);
    return result.fold((error) {
      _logger.e(
        "Error while fetching user profile from cache $error",
        error: error,
      );
      return emit(ProfileErrorState(error: error));
    }, (profile) {
      _logger.i("User profile fetched successfully");
      return emit(ProfileLoadedState(profile: profile));
    });
  }
}
