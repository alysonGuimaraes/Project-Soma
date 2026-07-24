import 'package:project_soma/features/movement/domain/entities/movement_entity.dart';

abstract class IMovementRepository {
  Future<void> insertMovement(MovementEntity movement);

  Future<List<MovementEntity>> getAllMovement();
  Future<MovementEntity?> getMovementById(String id);
  Future<List<MovementEntity>?> getMovementByFilters(
    Map<String, String> params,
  );

  Future<void> updateMovementById(String id, MovementEntity movement);
  Future<void> updateAllMovementsInCategory(
    String categoryId,
    Map<String, dynamic> params,
  );

  Future<void> deleteMovementById(String id);
}
