import 'package:academia/database/database.dart';
import 'package:academia/exports/barrel.dart';
import 'package:dartz/dartz.dart';
import 'package:drift/drift.dart' as drift;
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'user_local_repository.dart';
import 'user_remote_repository.dart';

final class UserRepository {
  final UserLocalRepository _userLocalRepository = UserLocalRepository();
  final UserRemoteRepository _userRemoteRepository = UserRemoteRepository();
  final _logger = Logger();

  /// Fetches all users from the local cache
  /// incase of an error it will return a [String] to the left
  /// and a [List<UserData>] to the right incase users were retrived
  Future<Either<String, UserData?>> fetchUserFromCache() async {
    return await _userLocalRepository.fetchUser();
  }

  /// Adds or updates a user's information into local cache depending
  /// on whether the user data exists
  Future<Either<String, bool>> addUserToCache(UserData userData) async {
    return await _userLocalRepository.addUserToCache(userData);
  }

  /// Delete the user specified by [userData] from local cache
  /// It wil return a string describing the error that it might have
  /// encountered or a boolean [true] incase it was a success
  Future<Either<String, bool>> deleteUserFromCache(UserData userData) async {
    return await _userLocalRepository.deleteUserFromCache(userData);
  }

  /// Adds or updates a user's information into local credentials cache depending
  /// on whether the user data exists
  Future<Either<String, bool>> addUserCredsToCache(
      UserCredentialData credentials) async {
    return await _userLocalRepository.addUserCredsToCache(credentials);
  }

  /// Retrieves user credentials from cache depending
  /// on whether the user data exists
  Future<Either<String, UserCredentialData>> fetchUserCredsFromCache(
      UserData user) async {
    return await _userLocalRepository.fetchUserCredsFromCache(user);
  }

  Future<Either<String, UserData>> authenticateRemotely(
      UserCredentialData credentials) async {
    // Register a magnet singleton instance

    GetIt.instance.registerSingletonIfAbsent(
      () => Magnet(credentials.admno!, credentials.password),
      instanceName: "magnet",
    );

    // authenticate with magnet
    final magnetResult =
        await (GetIt.instance.get<Magnet>(instanceName: "magnet").login());
    //Right(Object());
    return magnetResult.fold((error) {
      return left(error.toString());
    }, (session) async {
      final results =
          await _userRemoteRepository.verisafeAuthentication(credentials);
      return results.fold((error) {
        return left(error);
      }, (user) async {
        await addUserToCache(user);
        await addUserCredsToCache(UserCredentialData(
          email: user.email!,
          username: user.username,
          admno: credentials.admno,
          password: credentials.password,
          userId: user.id,
          lastLogin: DateTime.now(),
        ));
        return right(user);
      });
    });

    // authenticate with verisafe
  }

  Future<Either<String, Map<String, String>>> registerUser(
      UserCredentialData credentials) async {
    // Register a magnet singleton instance

    final magnet = GetIt.instance.registerSingletonIfAbsent(
      () => Magnet(credentials.admno!, credentials.password),
      instanceName: "magnet",
    );

    // authenticate with magnet
    final magnetResult = await (magnet.login());
    //Right(Object());
    return magnetResult.fold((error) {
      GetIt.instance.unregister(instance: magnet);
      return left(error.toString());
    }, (session) async {
      // Fetch the user details
      final detailsResult = await magnet.fetchUserDetails();
      return detailsResult.fold((error) {
        return left(error.toString());
      }, (user) {
        return right(user);
      });
    });
  }

  Future<Either<String, bool>> completeRegistration(
    UserData user,
    UserProfileData profile,
    UserCredentialData creds,
  ) async {
    final userResult = await _userRemoteRepository.registerUser(user);
    if (userResult.isLeft()) {
      _logger.e((userResult as Left).value);
      return left((userResult as Left).value);
    }

    user = (userResult as Right).value;
    _logger.i(user.toJson());

    final credsResult = await _userRemoteRepository
        .registerUserCredentials(creds.copyWith(userId: drift.Value(user.id)));
    if (credsResult.isLeft()) {
      _logger.e((credsResult as Left).value);
      return left((credsResult as Left).value);
    }

    //creds = (credsResult as Right).value;
    final credentials =
        ((credsResult as Right).value as UserCredentialData).copyWith(
      admno: drift.Value(creds.admno),
      password: creds.password,
      email: drift.Value(user.email),
      username: drift.Value(user.username),
    );

    final dob = DateTime.now();
    final profileResult = await _userRemoteRepository.createUserProfile(
      profile.copyWith(
        userId: user.id,
        dateOfBirth: dob.copyWith(
          year: profile.dateOfBirth.year,
          month: profile.dateOfBirth.month,
          day: profile.dateOfBirth.day,
          isUtc: true,
        ),
      ),
    );
    if (profileResult.isLeft()) {
      _logger.e((profileResult as Left).value);
      return left((profileResult as Left).value);
    }

    // Add the details to cache

    final userLocal = await _userLocalRepository.addUserToCache(user.copyWith(
      phone: drift.Value(''),
    ));
    if (userLocal.isLeft()) {
      _logger.e((userLocal as Left).value);
      return left((userLocal as Left).value);
    }

    final userprofileLocal = await _userLocalRepository
        .addUserProfile((profileResult as Right).value);
    if (userprofileLocal.isLeft()) {
      _logger.e((userLocal as Left).value);
      return left((userLocal as Left).value);
    }

    final usercredsLocal =
        await _userLocalRepository.addUserCredsToCache(credentials);
    if (usercredsLocal.isLeft()) {
      _logger.e((usercredsLocal as Left).value);
      return left((userLocal as Left).value);
    }

    _logger.i(
      "User successfully registered and data added to cache for rapid logins",
      time: DateTime.now(),
    );
    return right(true);
  }

  /// Retrieves a user's profile from the cache
  Future<Either<String, UserProfileData>> fetchUserProfileFromCache(
    UserData user,
  ) async {
    final localResult = await _userLocalRepository.fetchUserProfile(user);
    if (localResult.isRight()) {
      final profile = (localResult as Right).value;
      if (profile == null) {
        return left(
          "Failed to fetch your profile from cache please connect to the internet and refresh",
        );
      }
      return right((localResult as Right).value);
    }

    return Left((localResult as Left).value);
  }

  Future<Either<String, UserProfileData>> refreshUserProfile(
    UserData user,
  ) async {
    // Fetch from the remote db
    final remoteResult = await _userRemoteRepository.fetchUserProfile();
    if (remoteResult.isRight()) {
      final profile = (remoteResult as Right).value;
      await _userLocalRepository.addUserProfile(profile);
      return right(profile);
    }

    return (left((remoteResult as Left).value));
  }
}
