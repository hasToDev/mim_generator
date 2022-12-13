import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import '../../core/core.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // -------------------------------- CORE --------------------------------
  // Provider
  sl.registerLazySingleton(
    () => ApiDataProvider(
      picker: sl(),
      fetchMemeData: sl(),
    ),
  );

  // Use Cases
  sl.registerLazySingleton(() => FetchMemeData(sl()));

  // Repository
  sl.registerLazySingleton<DataRepository>(
    () => DataRepositoryImpl(
      remoteDataSource: sl(),
    ),
  );

  // Data sources
  sl.registerLazySingleton<MemeRemoteData>(
    () => MemeRemoteDataImpl(httpHelper: sl()),
  );

  // -------------------------------- HELPER --------------------------------
  // HTTP Request Helper
  sl.registerLazySingleton<HttpRequestHelper>(() => HttpRequestHelperImpl(client: sl()));

  // -------------------------------- PACKAGE --------------------------------
  // Http
  sl.registerLazySingleton(() => http.Client());

  // Image Picker
  sl.registerLazySingleton(() => ImagePicker());
}
