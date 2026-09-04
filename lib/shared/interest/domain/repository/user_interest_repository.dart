import 'package:dynamic_app/shared/interest/domain/entities/category_interest.dart';

abstract interface class UserInterestRepository {
  Future<List<CategoryInterest>> getTopCategories({int limit = 5});
}
