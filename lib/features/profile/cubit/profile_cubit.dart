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
    final result = await _userRepository.fetchUserProfileFromCache(user);
    result.fold((error) {
      _logger.e("Error while fetching user profile from cache $error",
          error: error);
      emit(ProfileErrorState(error: error));
    }, (profile) {
      _logger.i("User profile fetched successfully");
      emit(ProfileLoadedState(profile: profile));
    });
  }
}
