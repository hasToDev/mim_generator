import 'package:dartz/dartz.dart';
import '../../../core/core.dart';

class DataRepositoryImpl implements DataRepository {
  final MemeRemoteData remoteDataSource;

  DataRepositoryImpl({
    required this.remoteDataSource,
  });

  @override
  Future<Either<Failure, List<MemePicture>>> fetchMemeData() async {
    try {
      final remoteData = await remoteDataSource.fetchMemeData();
      return Right(remoteData);
    } on ServerException catch (e) {
      return Left(ServerFailure(
        message: e.message,
        code: e.code,
      ));
    } catch (e, stacktrace) {
      return Left(UnknownFailure(
        message: '$e\n$stacktrace',
        code: 255,
      ));
    }
  }
}
