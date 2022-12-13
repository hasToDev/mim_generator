import 'package:dartz/dartz.dart';
import '../../../core/core.dart';

abstract class DataRepository {
  Future<Either<Failure, List<MemePicture>>> fetchMemeData();
}
