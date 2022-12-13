import 'package:dartz/dartz.dart';
import '../../core.dart';

class FetchMemeData implements UseCase<List<MemePicture>, NoParams> {
  final DataRepository repository;

  FetchMemeData(this.repository);

  @override
  Future<Either<Failure, List<MemePicture>>> call(NoParams params) async {
    return await repository.fetchMemeData();
  }
}
