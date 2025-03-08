part of 'in_app_update_cubit.dart';

abstract class InAppUpdateState {}

class InAppUpdateInitial extends InAppUpdateState {}

class InAppUpdateLoading extends InAppUpdateState {}

class InAppUpdateAvailable extends InAppUpdateState {
  final AppUpdateInfo updateInfo;

  InAppUpdateAvailable({required this.updateInfo});
}

class InAppUpdateNoUpdate extends InAppUpdateState {}

class InAppUpdateInProgress extends InAppUpdateState {}

class InAppUpdateCompleted extends InAppUpdateState {}

class InAppUpdateError extends InAppUpdateState {
  final String errorMessage;

  InAppUpdateError({required this.errorMessage});
}
