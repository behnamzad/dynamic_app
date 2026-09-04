import 'package:dynamic_app/shared/interest/domain/entities/category_interest.dart';
import 'package:dynamic_app/shared/interest/domain/repository/user_interest_repository.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class UserInterestManager {
  const UserInterestManager(this._repository);

  final UserInterestRepository _repository;

  Future<List<CategoryInterest>> topCategories({int limit = 5}) {
    return _repository.getTopCategories(limit: limit);
  }
}
