import 'package:project_soma/features/movement/domain/entities/movement_entity.dart';
import 'package:project_soma/features/movement/domain/repositories/i_movement_repository.dart';

import '../../../../core/connection/database_connection.dart';

class MovementRepositoryImpl implements IMovementRepository {
  final DatabaseConnection databaseConnection;

  MovementRepositoryImpl(this.databaseConnection);

  @override
  Future<void> deleteMovementById(String id) {
    // TODO: implement deleteMovementById
    throw UnimplementedError();
  }

  @override
  Future<List<MovementEntity>> getAllMovement() {
    // TODO: implement getAllMovement
    throw UnimplementedError();
  }

  @override
  Future<List<MovementEntity>?> getMovementByFilters(
    Map<String, String> params,
  ) {
    // TODO: implement getMovementByFilters
    throw UnimplementedError();
  }

  @override
  Future<MovementEntity?> getMovementById(String id) {
    // TODO: implement getMovementById
    throw UnimplementedError();
  }

  @override
  Future<void> insertMovement(MovementEntity movement) {
    // TODO: implement insertMovement
    throw UnimplementedError();
  }

  @override
  Future<void> updateAllMovementsInCategory(
    String categoryId,
    Map<String, dynamic> params,
  ) {
    // TODO: implement updateAllMovementsInCategory
    throw UnimplementedError();
  }

  @override
  Future<void> updateMovementById(String id, MovementEntity movement) {
    // TODO: implement updateMovementById
    throw UnimplementedError();
  }
}
