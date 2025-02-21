import 'package:academia/database/database.dart';
import 'package:academia/utils/network/network.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

final class UserRemoteRepository with DioErrorHandler {
  final DioClient _client = DioClient();

  /// The function attempts to authenticate a users [credentials] with
  /// verisafe. If okay it returns the [UserData] otherwise it just
  /// returns a string with a message of what exactly went wrong
  Future<Either<String, UserData>> verisafeAuthentication(
    UserCredentialData credentials,
  ) async {
    try {
      final response = await _client.dio.post(
        "/v2/auth/authenticate",
        data: credentials.toJson(),
      );

      if (response.statusCode == 200) {
        return right(UserData.fromJson(response.data));
      }

      return left(response.data["message"] ?? response.statusMessage);
    } on DioException catch (de) {
      return handleDioError(de);
    } catch (e) {
      return left("Something went terribly wrong please try that later");
    }
  }

  /// The function attempts to fetch a user's profile from verisafe
  /// In the event of success it retuns the [UserProfileData]
  /// and in case of failure it retuns a string indicating what exactly
  /// went wrong
  Future<Either<String, UserProfileData>> fetchUserProfile() async {
    try {
      final response = await _client.dio.get("verisafe/v2/users/profile");
      if (response.statusCode == 200) {
        return right(UserProfileData.fromJson(response.data));
      }

      return left(response.data["error"] ?? response.statusMessage);
    } on DioException catch (de) {
      return handleDioError(de);
    } catch (e) {
      return left("Something went terribly wrong please try that later");
    }
  }

  Future<Either<String, UserData>> registerUser(UserData rawUser) async {
    try {
      final response = await _client.dio.post(
        "/v2/users/register",
        data: rawUser.toJson(),
      );

      if (response.statusCode == 201) {
        return right(UserData.fromJson(response.data));
      }
      return left(response.data["message"] ?? response.statusMessage);
    } on DioException catch (de) {
      return handleDioError(de);
    } catch (e) {
      return left("Something went terribly wrong please try that later");
    }
  }

  Future<Either<String, UserProfileData>> createUserProfile(
      UserProfileData profile) async {
    try {
      final response = await _client.dio.post(
        "/v2/users/profile/create",
        data: profile.toJson(),
      );

      if (response.statusCode == 201) {
        return right(UserProfileData.fromJson(response.data));
      }
      return left(response.data["message"] ?? response.statusMessage);
    } on DioException catch (de) {
      return handleDioError(de);
    } catch (e) {
      rethrow;
    }
  }

  Future<Either<String, UserCredentialData>> registerUserCredentials(
      UserCredentialData rawCredentials) async {
    try {
      final response = await _client.dio.post(
        "/v2/credentials/create",
        data: rawCredentials.toJson(),
      );

      if (response.statusCode == 201) {
        return right(UserCredentialData.fromJson(response.data));
      }
      return left(response.data["message"] ?? response.statusMessage);
    } on DioException catch (de) {
      return handleDioError(de);
    } catch (e) {
      rethrow;
    }
  }
}
