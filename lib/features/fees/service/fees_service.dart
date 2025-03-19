import 'package:academia/exports/barrel.dart';
import 'package:dartz/dartz.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';

final class FeesService {
  final Logger _logger = Logger();
  Future<Either<String, List<Map<String, dynamic>>>>
      fetchFeesTransactions() async {
    final magnetInstance = GetIt.instance.get<Magnet>(instanceName: "magnet");
    try {
      magnetInstance.token;
    } catch (e) {
      _logger.e("Token was null attempting to refresh token");
      final result = await magnetInstance.login();
      if (result.isLeft()) {
        _logger.e((result as Left).value);
        return left("Please check your internet connection and retry again!");
      }
    }

    _logger.i("Magnet token refreshed attempting to fetch courses");

    final magnetResult = await magnetInstance.fetchFeeStatement();
    return magnetResult.fold((error) {
      return left(error.toString());
    }, (transactions) {
      return right(transactions);
    });
  }
}
