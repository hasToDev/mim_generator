import 'dart:convert';
import '../../../core/core.dart';

abstract class MemeRemoteData {
  Future<List<MemePicture>> fetchMemeData();
}

class MemeRemoteDataImpl implements MemeRemoteData {
  final HttpRequestHelper httpHelper;

  MemeRemoteDataImpl({
    required this.httpHelper,
  });

  @override
  Future<List<MemePicture>> fetchMemeData() async {
    String url = 'https://api.imgflip.com/get_memes';
    Map<String, String> headers = {'Accept': 'application/json'};

    final response = await httpHelper.getRequest(url: url, headers: headers);
    Map<String, dynamic> result = json.decode(response.body);

    if (response.statusCode >= 200 && response.statusCode < 300 && result['success']) {
      List<MemePicture> memePictureList = [];
      List<dynamic> memeList = result['data']['memes'];

      for (var i = 0; i < memeList.length; i++) {
        memePictureList.add(MemePicture.fromJson(memeList[i]));
      }

      return memePictureList;
    } else {
      throw ServerException(
        message: 'fetchMemeData failed',
        code: response.statusCode,
      );
    }
  }
}
